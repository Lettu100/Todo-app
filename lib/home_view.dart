import 'package:advance/create_todo_view.dart';
import 'package:advance/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//stl => stateless widget
//stf => stateful widget

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedItem = 'todo';

  final List<Map<String, dynamic>> unCompletedData = [];

  final List<Map<String, dynamic>> completedData = [];

  final List<Map<String, dynamic>> data = [
    {
      'title': 'Lorem Ipsum is simply dummy  and going to Tekyiman',
      'description':
          'Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      'date_time': 'Yesterday',
      'status': true
    },
    {
      'title':
          'Lorem Ipsum is simply dummy text of the printing and going to bolga .',
      'description':
          'Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      'date_time': 'Today',
      'status': true
    },
    {
      'title':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      'description':
          'Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      'date_time': 'Tomorrow',
      'status': false
    },
    {
      'title': 'Printing and typesetting industry via some lines of code.',
      'description':
          'Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      'date_time': 'Today',
      'status': false
    },
    {
      'title': 'Dummy text of the printing and typesetting industry',
      'description':
          'Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      'date_time': 'Mon. 15 Nov ',
      'status': false
    }
  ];

  @override
  void initState() {
    for (Map<String, dynamic> element in data) {
      if (!element['status']) {
        unCompletedData.add(element);
      } else {
        completedData.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
        ),
        leading: const Center(
            child: FlutterLogo(
          size: 40,
        )),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                setState(() {
                  selectedItem = value.toString();
                });
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(child: Text('Todo'), value: 'todo'),
                  PopupMenuItem(
                    child: Text('Completed'),
                    value: 'completed',
                  )
                ];
              }),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateTodoView();
          }));
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(37, 43, 103, 1),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              SizedBox(
                width: constraints.maxWidth/2,
                height: MediaQuery.of(context).size.height,
                child: TodoListViewWidget(
            selectedItem: selectedItem,
            unCompletedData: unCompletedData,
            completedData: completedData),
              ),
            Expanded(
              child: Container(
                 
                color: Colors.red,
              ),
            )
            ],
          );
        }
        return TodoListViewWidget(
            selectedItem: selectedItem,
            unCompletedData: unCompletedData,
            completedData: completedData);
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: InkWell(
            onTap: () {
              showBarModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return TaskCardWidget(
                            dateTime: completedData[index]['date_time'],
                            description: completedData[index]['description'],
                            title: completedData[index]['title'],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: completedData.length);
                  });
            },
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(37, 43, 103, 1),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "Completed",
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      '${completedData.length}',
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TodoListViewWidget extends StatelessWidget {
  const TodoListViewWidget({
    Key? key,
    required this.selectedItem,
    required this.unCompletedData,
    required this.completedData,
  }) : super(key: key);

  final String selectedItem;
  final List<Map<String, dynamic>> unCompletedData;
  final List<Map<String, dynamic>> completedData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
     // shrinkWrap: true,
      scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return TaskCardWidget(
              dateTime: selectedItem == 'todo'
                  ? unCompletedData[index]['date_time']
                  : completedData[index]['date_time'],

              //title
              title: selectedItem == 'todo'
                  ? unCompletedData[index]['title']
                  : completedData[index]['title'],

              //description
              description: selectedItem == 'todo'
                  ? unCompletedData[index]['description']
                  : completedData[index]['description']);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: selectedItem == 'todo'
            ? unCompletedData.length
            : completedData.length);
  }
}

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.dateTime})
      : super(key: key);

  final String title;
  final String description;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.lightBlue,
      //margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 30,
              color: customColor(
                date: dateTime,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(37, 43, 103, 1)),
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            const SizedBox(width: 15),
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: customColor(
                    date: dateTime,
                  ),
                ),
                Text(
                  dateTime,
                  style: TextStyle(color: customColor(date: dateTime)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
