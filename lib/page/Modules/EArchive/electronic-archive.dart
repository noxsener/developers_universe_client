import 'package:developersuniverse_client/page/Modules/EArchive/electronic-archive-controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../models/common-model.dart';
import '../../../services/common-service.dart';

class ElectronicArchivePage extends StatefulWidget {
  const ElectronicArchivePage({Key? key}) : super(key: key);

  @override
  State<ElectronicArchivePage> createState() => _ElectronicArchivePageState();
}

class _ElectronicArchivePageState extends State<ElectronicArchivePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ElectronicArchivePage> {
  final c = Get.put(ElectronicArchivePageController());
  late bool landscape;

  @override
  void initState() {
    super.initState();
    c.initState(context, this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      landscape = orientation == Orientation.landscape;
      SingleChildScrollView(
        key: const ValueKey("modulesMenu"),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.green
                  ),
                  child: IconButton(
                    splashColor: Colors.green,
                    icon: const Icon(FontAwesomeIcons.folderPlus),
                    color: Colors.white,
                    onPressed: () {
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.green
                  ),
                  child: IconButton(
                    splashColor: Colors.green,
                    icon: const Icon(FontAwesomeIcons.fileCirclePlus),
                    color: Colors.white,
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: c.electronicArchiveList.length,
              itemBuilder: (BuildContext ctx, index) {
                ElectronicArchive electronicArchiveIndex = c.electronicArchiveList[index];

                return ListTile(
                  leading: Image.asset(iconFromFileExtension(electronicArchiveIndex.name)),
                  title: Text(
                    electronicArchiveIndex.name ?? "No named file",
                    style: theme.textTheme().labelMedium,
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        electronicArchiveIndex.description ?? "",
                        style: theme.textTheme().labelSmall,
                      ),
                      Text(
                        getFileSize(electronicArchiveIndex.size ?? 0),
                        style: theme.textTheme().labelSmall,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: null,
                  //const Icon(Icons.download, color: Colors.white70,),
                );
              },
            )
          ],
        ),
      ),
    );
  }

}
