import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/athlete_check_dto.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/training_details/training_details_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'athlete_checks_viewmodel.dart';

class AthleteChecksScreen extends StatelessWidget {
  const AthleteChecksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AthleteChecksViewModel>(
      create: (_) => locator<AthleteChecksViewModel>(),
      child: Consumer<AthleteChecksViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Check-ins'),
            ),
            body: FutureBuilder(
              future: model.getAthleteChecks(),
              builder: (
                context,
                AsyncSnapshot<Result<List<AthleteCheckDTO>>> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final result = snapshot.data!;
                      if (result.success && result.data!.isNotEmpty) {
                        return AthleteChecksList(
                          checks: result.data!,
                          model: model,
                        );
                      }
                      if (result.success && result.data!.isEmpty) {
                        return const PerseuMessage(
                          message: 'Nenhum check-in ainda',
                          icon: Icons.mood_bad,
                        );
                      }
                    }
                    return PerseuMessage.defaultError();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class AthleteChecksList extends StatefulWidget {
  const AthleteChecksList({
    Key? key,
    required this.checks,
    required this.model,
  }) : super(key: key);

  final AthleteChecksViewModel model;
  final List<AthleteCheckDTO> checks;

  @override
  State<AthleteChecksList> createState() => _AthleteChecksListState();
}

class _AthleteChecksListState extends State<AthleteChecksList> {
  @override
  void initState() {
    widget.model.dayChecks = widget.model.loadChecks(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: TableCalendar(
              locale: 'pt_BR',
              focusedDay: widget.model.focusedDay,
              lastDay: widget.model.kLastDay,
              firstDay: widget.model.kFirstDay,
              calendarFormat: widget.model.calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mês',
                CalendarFormat.twoWeeks: '2 semanas',
                CalendarFormat.week: 'Semana'
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Palette.accent.withOpacity(.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Palette.secondary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Palette.accent,
                  shape: BoxShape.circle,
                ),
              ),
              onFormatChanged: (format) {
                setState(() {
                  widget.model.calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(widget.model.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  widget.model.selectedDay = selectedDay;
                  widget.model.focusedDay = focusedDay;
                  widget.model.dayChecks = widget.model.loadChecks(selectedDay);
                });
              },
              eventLoader: (day) => widget.model.loadChecks(day),
              onPageChanged: (focusedDay) {
                widget.model.focusedDay = focusedDay;
              },
            ),
          ),
        ),
        const AccentDivider(),
        Expanded(
          child: widget.model.dayChecks.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: widget.model.dayChecks.length,
                    itemBuilder: (context, index) {
                      final AthleteCheckDTO check =
                          widget.model.dayChecks[index];
                      return Card(
                        margin: const EdgeInsets.only(top: 8),
                        child: ListTile(
                          title: Text(
                            '${Formatters.effortFormatter(check.effort)}  '
                            '${DateFormatters.toTimeString(check.date)} | '
                            '${check.training.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.primary),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward,
                            color: Palette.secondary,
                            size: 28,
                          ),
                          onTap: () =>
                              Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TrainingDetailsScreen(
                                trainingId: check.training.id,
                                trainingName: check.training.name,
                                dateTimeCheck: check.date,
                                effort: check.effort,
                              );
                            },
                          )),
                        ),
                      );
                    },
                  ),
                )
              : const PerseuMessage(
                  message: 'Nenhum check-in nesse dia',
                  withoutIcon: true,
                ),
        ),
      ],
    );
  }
}
