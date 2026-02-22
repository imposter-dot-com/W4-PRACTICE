import 'package:flutter/material.dart';
 
import 'download_controler.dart';
import '../../../theme/theme.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;
 
 // TODO
  Widget _buildIcon(){
    switch(controller.status){
      case DownloadStatus.notDownloaded:
        return const Icon(Icons.download);
      case DownloadStatus.downloading:
        return const Icon(Icons.motion_photos_on);
      case DownloadStatus.downloaded:
        return const Icon(Icons.folder);
    }
  }

  String _buildSubtitle(){
    final percentage = (controller.progress * 100).toString();
    final downloaded = (controller.progress * controller.ressource.size).toString();
    final total = controller.ressource.size;
    return '$percentage % completed - $downloaded of $total MB'; 
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller, 
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListTile(
                title: Text(controller.ressource.name, style: AppTextStyles.label.copyWith(color: AppColors.neutralDark)),
                subtitle: controller.status != DownloadStatus.notDownloaded ? Text(_buildSubtitle(), style: TextStyle(color: AppColors.neutralLight)) : null,
                trailing: GestureDetector(
                  onTap: controller.status == DownloadStatus.notDownloaded ? controller.startDownload : null,
                  child: _buildIcon(),
                ),
              ),
            ),
          );
      }
      );
  }
}
