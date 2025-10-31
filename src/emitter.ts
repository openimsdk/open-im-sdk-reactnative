import { EmitterSubscription } from 'react-native';
import { OpenIMEvent } from './constants/OpenIMEvents';
import { NativeOpenIMEmitter } from './OpenIMSDK.native';
import { ArgsOfEvent } from './types/eventArgs';

interface EmitterInterface {
  on<E extends EventName>(eventName: E, callback: (...args: ArgsOfEvent<E>) => void): void;
  off<E extends EventName>(eventName: E, callback: (...args: ArgsOfEvent<E>) => void): void;
}

type EventName = typeof OpenIMEvent[keyof typeof OpenIMEvent];

type NativeSubscriptionAndCallbackPair = {
  subscription: EmitterSubscription;
  callback: (...args: any) => void;
};

class Emitter implements EmitterInterface {
  private pairsMap: Map<EventName, NativeSubscriptionAndCallbackPair[]>;

  constructor(){
    this.pairsMap = new Map();
  }

  on<E extends EventName>(eventName: E, callback: (...args: ArgsOfEvent<E>) => void): void {
    const subscription = NativeOpenIMEmitter.addListener(eventName, (...data) => {
      callback(...data as ArgsOfEvent<E>)
    });

    const pair = this.pairsMap.get(eventName) || [];
    pair.push({ subscription, callback });
    this.pairsMap.set(eventName, pair);
  }

  off<E extends EventName>(eventName: E, callback: (...args: ArgsOfEvent<E>) => void): void {
    const pairs = this.pairsMap.get(eventName);
    if (!pairs) return;

    const pair = pairs.find((candidate) => candidate.callback === callback);
    if (pair) {
      /**
       * NOTE: When removing listeners in a useEffect cleanup, calling
       * NativeOpenIMEmitter.removeSubscription(subscription) can throw a
       * "method not found" error. Prefer subscription.remove(), which works
       * reliably. This appears to be a React Native bug.
       */
      // NativeOpenIMEmitter.removeSubscription(pair.subscription); 
      pair.subscription.remove();
      pairs.splice(pairs.indexOf(pair), 1);
      this.pairsMap.set(eventName, pairs);
    }
  }
}

export default Emitter;
