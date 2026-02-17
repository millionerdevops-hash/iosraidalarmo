import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'server_list_view_model.dart';
import '../../config/rust_colors.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverListAsync = ref.watch(serverListViewModelProvider);

    return Scaffold(
      backgroundColor: RustColors.background,
      appBar: AppBar(
        title: const Text("RaidCapture"),
        backgroundColor: RustColors.surface,
        foregroundColor: RustColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               ref.read(serverListViewModelProvider.notifier).scanForServers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings
            },
          )
        ],
      ),
      body: serverListAsync.when(
        data: (servers) {
          if (servers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No servers paired yet.", style: TextStyle(color: RustColors.textSecondary)),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => context.go('/login'), // Start pairing flow
                    icon: const Icon(Icons.add),
                    label: const Text("Pair with Server"),
                    style: FilledButton.styleFrom(backgroundColor: RustColors.primary),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              return ListTile(
                title: Text(server.name ?? "Unknown Server", style: const TextStyle(color: RustColors.textPrimary, fontWeight: FontWeight.bold)),
                subtitle: Text("${server.ip}:${server.port}", style: const TextStyle(color: RustColors.textSecondary)),
                trailing: const Icon(Icons.chevron_right, color: RustColors.textMuted),
                onTap: () {
                  context.go('/server/${server.id}', extra: {'name': server.name});
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: RustColors.primary)),
        error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: RustColors.error))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/login'),
        backgroundColor: RustColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
