// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lib/core/proto/**

part of 'server_dashboard_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverDashboardViewModelHash() =>
    r'212a0565e1bfa3de9057136077bd4f963d6eb1b1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ServerDashboardViewModel
    extends BuildlessAutoDisposeStreamNotifier<List<SmartDevice>> {
  late final int serverId;

  Stream<List<SmartDevice>> build(
    int serverId,
  );
}

/// See also [ServerDashboardViewModel].
@ProviderFor(ServerDashboardViewModel)
const serverDashboardViewModelProvider = ServerDashboardViewModelFamily();

/// See also [ServerDashboardViewModel].
class ServerDashboardViewModelFamily
    extends Family<AsyncValue<List<SmartDevice>>> {
  /// See also [ServerDashboardViewModel].
  const ServerDashboardViewModelFamily();

  /// See also [ServerDashboardViewModel].
  ServerDashboardViewModelProvider call(
    int serverId,
  ) {
    return ServerDashboardViewModelProvider(
      serverId,
    );
  }

  @override
  ServerDashboardViewModelProvider getProviderOverride(
    covariant ServerDashboardViewModelProvider provider,
  ) {
    return call(
      provider.serverId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serverDashboardViewModelProvider';
}

/// See also [ServerDashboardViewModel].
class ServerDashboardViewModelProvider
    extends AutoDisposeStreamNotifierProviderImpl<ServerDashboardViewModel,
        List<SmartDevice>> {
  /// See also [ServerDashboardViewModel].
  ServerDashboardViewModelProvider(
    int serverId,
  ) : this._internal(
          () => ServerDashboardViewModel()..serverId = serverId,
          from: serverDashboardViewModelProvider,
          name: r'serverDashboardViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serverDashboardViewModelHash,
          dependencies: ServerDashboardViewModelFamily._dependencies,
          allTransitiveDependencies:
              ServerDashboardViewModelFamily._allTransitiveDependencies,
          serverId: serverId,
        );

  ServerDashboardViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serverId,
  }) : super.internal();

  final int serverId;

  @override
  Stream<List<SmartDevice>> runNotifierBuild(
    covariant ServerDashboardViewModel notifier,
  ) {
    return notifier.build(
      serverId,
    );
  }

  @override
  Override overrideWith(ServerDashboardViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ServerDashboardViewModelProvider._internal(
        () => create()..serverId = serverId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serverId: serverId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ServerDashboardViewModel,
      List<SmartDevice>> createElement() {
    return _ServerDashboardViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServerDashboardViewModelProvider &&
        other.serverId == serverId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serverId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServerDashboardViewModelRef
    on AutoDisposeStreamNotifierProviderRef<List<SmartDevice>> {
  /// The parameter `serverId` of this provider.
  int get serverId;
}

class _ServerDashboardViewModelProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ServerDashboardViewModel,
        List<SmartDevice>> with ServerDashboardViewModelRef {
  _ServerDashboardViewModelProviderElement(super.provider);

  @override
  int get serverId => (origin as ServerDashboardViewModelProvider).serverId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
