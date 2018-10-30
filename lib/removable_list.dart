import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

enum RemovableAction {
  reset,
  horizontalSwipe,
  leftSwipe,
  rightSwipe
}

class RemovableItem implements Comparable<RemovableItem> {
  RemovableItem({this.index, this.name, this.subject});

  final int index;
  final String name;
  final String subject;

  @override
  int compareTo(RemovableItem other) {
    return index.compareTo(other.index);
  }

}

class RemovableList extends StatefulWidget {

  @override
  State createState() => new RemovableListState();
}

class RemovableListState extends State<RemovableList> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  DismissDirection _dismissDirection = DismissDirection.endToStart;
  List<RemovableItem> removableItems;

  void initListItems() {
    removableItems = new List<RemovableItem>.generate(20, (int index) {
      return new RemovableItem(
          index: index,
          name: 'Item $index',
          subject: 'Subject $index'
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initListItems();
  }

  void handleUndo(RemovableItem item) {
    final int insertionIndex = lowerBound(removableItems, item);
    setState(() {
      removableItems.insert(insertionIndex, item);
    });
  }

  void _handleDelete(RemovableItem item) {
    setState(() {
      removableItems.remove(item);
    });
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text('Deleted item ${item.index}'),
      action: new SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            handleUndo(item);
          }),
    ));
  }

  void handleSwipeAction(RemovableAction action) {
    setState(() {
      switch (action) {
        case RemovableAction.reset:
          initListItems();
          break;
        case RemovableAction.horizontalSwipe:
          _dismissDirection = DismissDirection.horizontal;
          break;
        case RemovableAction.leftSwipe:
          _dismissDirection = DismissDirection.endToStart;
          break;
        case RemovableAction.rightSwipe:
          _dismissDirection = DismissDirection.startToEnd;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (removableItems.isEmpty) {
      body = new Center(
        child: new RaisedButton(
          onPressed: () => handleSwipeAction(RemovableAction.reset),
          child: const Text('Reset'),
        ),
      );
    } else {
      body = new ListView.builder(
          itemCount: removableItems.length,

          itemBuilder: (context, i) {
            return new _RemovableListItem(
                item: removableItems[i],
                onDelete: _handleDelete,
                dismissDirection: _dismissDirection);
          }
      );
    }

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Swipe to delete'),
        actions: <Widget>[
          new PopupMenuButton<RemovableAction>(
            itemBuilder: (context) =>
            <PopupMenuEntry<RemovableAction>>[
              const PopupMenuItem<RemovableAction>(
                  value: RemovableAction.reset,
                  child: Text('Reset the list')
              ),
              const PopupMenuDivider(),
              new CheckedPopupMenuItem<RemovableAction>(
                  value: RemovableAction.horizontalSwipe,
                  checked: _dismissDirection == DismissDirection.horizontal,
                  child: const Text('Horizontal swipe')
              ),
              new CheckedPopupMenuItem<RemovableAction>(
                  value: RemovableAction.leftSwipe,
                  checked: _dismissDirection == DismissDirection.endToStart,
                  child: const Text('Only swipe left')
              ),
              new CheckedPopupMenuItem<RemovableAction>(
                  value: RemovableAction.rightSwipe,
                  checked: _dismissDirection == DismissDirection.startToEnd,
                  child: const Text('Only swipe right')
              )
            ],
            onSelected: handleSwipeAction,
          )
        ],
      ),
      body: body,
    );
  }
}

class _RemovableListItem extends StatelessWidget {
  const _RemovableListItem({
    Key key,
    @required this.item,
    @required this.onDelete,
    @required this.dismissDirection,
  }) : super(key: key);

  final RemovableItem item;
  final DismissDirection dismissDirection;
  final void Function(RemovableItem) onDelete;

  void _handleDelete() {
    onDelete(item);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Semantics(
      customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
        const CustomSemanticsAction(label: 'Delete'): _handleDelete,
      },
      child: new Dismissible(
        key: new ObjectKey(item),
        direction: dismissDirection,
        onDismissed: (DismissDirection direction) {
          _handleDelete();
        },
        background: new Container(
            color: theme.primaryColor,
            child: const ListTile(
                leading: Icon(Icons.delete, color: Colors.white, size: 36.0),
                trailing: Icon(Icons.delete, color: Colors.white, size: 36.0)
            )
        ),
        child: new Container(
          decoration: new BoxDecoration(
              color: theme.canvasColor,
              border: new Border(
                  bottom: new BorderSide(color: theme.dividerColor))
          ),
          child: new ListTile(
              title: new Text(item.name),
              subtitle: new Text('${item.subject}'),
              isThreeLine: true
          ),
        ),
      ),
    );
  }
}