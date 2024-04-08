//
//  Generated code. Do not modify.
//  source: grpc_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'grpc_service.pb.dart' as $0;

export 'grpc_service.pb.dart';

@$pb.GrpcServiceName('restaum.GrpcService')
class GrpcServiceClient extends $grpc.Client {
  static final _$runCommand = $grpc.ClientMethod<$0.CommandMessage, $0.ResponseMessage>(
      '/restaum.GrpcService/runCommand',
      ($0.CommandMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ResponseMessage.fromBuffer(value));

  GrpcServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ResponseMessage> runCommand($0.CommandMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$runCommand, request, options: options);
  }
}

@$pb.GrpcServiceName('restaum.GrpcService')
abstract class GrpcServiceBase extends $grpc.Service {
  $core.String get $name => 'restaum.GrpcService';

  GrpcServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CommandMessage, $0.ResponseMessage>(
        'runCommand',
        runCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CommandMessage.fromBuffer(value),
        ($0.ResponseMessage value) => value.writeToBuffer()));
  }

  $async.Future<$0.ResponseMessage> runCommand_Pre($grpc.ServiceCall call, $async.Future<$0.CommandMessage> request) async {
    return runCommand(call, await request);
  }

  $async.Future<$0.ResponseMessage> runCommand($grpc.ServiceCall call, $0.CommandMessage request);
}
