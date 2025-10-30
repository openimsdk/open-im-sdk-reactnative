import { default as OpenIMSDK }  from './sdk';
export default OpenIMSDK;

// Legacy event listeners used the native module's emitter directly.
// They are now wrapped; prefer OpenIMSDK.on and OpenIMSDK.off.
// For backward compatibility, we still export NativeOpenIMEmitter as OpenIMEmitter.
export { NativeOpenIMEmitter as OpenIMEmitter } from './OpenIMSDK.native';

export * from './constants/OpenIMEvents';
export * from './errors/OpenIMApiError';
export * from './errors/OpenIMEventError';
export * from './types/entity';
export * from './types/enum';
export * from './types/eventArgs';
export * from './types/params';
