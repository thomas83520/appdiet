import 'package:appdiet/data/models/goal/goals.dart';
import 'package:appdiet/logic/blocs/goal_bloc/goal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable/expandable.dart';

class GoalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        value: state.goals.pourcentageLong / 100,
                        strokeWidth: 15.0,
                        backgroundColor: Colors.orange[100],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(
                      child: CircularProgressIndicator(
                        value: state.goals.pourcentageShort / 100,
                        strokeWidth: 15.0,
                        backgroundColor: Colors.green[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      height: 120,
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                      width: 10,
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                    Text(" Objectifs court termes"),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                    Text(" Objectifs long termes"),
                  ],
                ),
                _buildcard(
                  "Objectifs long terme",
                  state.goals.pourcentageLong,
                  Colors.orange,
                  state.goals.longTerm,
                  context,
                  GoalType.longTerm,
                  state.goals,
                ),
                _buildcard(
                  "Objectifs court terme",
                  state.goals.pourcentageShort,
                  Colors.green,
                  state.goals.shortTerm,
                  context,
                  GoalType.shortTerm,
                  state.goals,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildListObjectifs(
      List<Goal> listGoal, BuildContext context, GoalType type, Goals goals) {
    return listGoal
        .asMap()
        .map(
          (index, goal) {
            return MapEntry(
                index,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: goal.isDone
                      ? Container(
                          color: Colors.grey,
                          child: Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (bool) => context
                                    .read<GoalBloc>()
                                    .add(GoalSelected(
                                        id: index, type: type, goals: goals)),
                              ),
                              Text(goal.goalName)
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool) => context
                                    .read<GoalBloc>()
                                    .add(GoalSelected(
                                        id: index, type: type, goals: goals)),
                              ),
                              Text(goal.goalName)
                            ],
                          ),
                        ),
                ));
          },
        )
        .values
        .toList();
  }

  Widget _buildcard(String text, double pourcentage, Color color,
      List<Goal> listGoal, BuildContext context, GoalType type, Goals goals) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: color,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: false,
                ),
                header: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    text + " " + pourcentage.toString() + "%",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                    ),
                  ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: listGoal.isEmpty
                      ? []
                      : _buildListObjectifs(listGoal, context, type, goals),
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
