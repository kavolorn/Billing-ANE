package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;

	import ru.kavolorn.ane.Billing;
	import ru.kavolorn.ane.BillingEvent;

	public class Billing_Demo extends Sprite
	{
		private var _label:TextField;
		private var _productId:String = "android.test.purchased";
		
		public function Billing_Demo()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function completeHandler(event:Event):void
		{
			_label = new TextField();
			_label.width = stage.stageWidth;
			_label.height = stage.stageHeight;
			_label.text += "Starting Billing Demo";
			addChild(_label);
			
			Billing.setDebug(true);
			Billing.getInstance().addEventListener(BillingEvent.INITIALIZATION_SUCCESS, initializationSuccessHandler);
			Billing.getInstance().addEventListener(BillingEvent.INITIALIZATION_ERROR, initializationErrorHandler);
			Billing.getInstance().addEventListener(BillingEvent.SERVICE_CONNECTED, serviceConnectedHandler);
			Billing.getInstance().addEventListener(BillingEvent.SERVICE_DISCONNECTED, serviceDisconnectedHandler);
			Billing.getInstance().addEventListener(BillingEvent.SKU_DETAILS_SUCCESS, skuDetailsSuccessHandler);
			Billing.getInstance().addEventListener(BillingEvent.SKU_DETAILS_ERROR, skuDetailsErrorHandler);
			Billing.getInstance().addEventListener(BillingEvent.PURCHASE_SUCCESS, purchaseSuccessHandler);
			Billing.getInstance().addEventListener(BillingEvent.PURCHASE_ERROR, purchaseErrorHandler);
			Billing.getInstance().addEventListener(BillingEvent.GET_PURCHASES_SUCCESS, getPurchasesSuccessHandler);
			Billing.getInstance().addEventListener(BillingEvent.GET_PURCHASES_ERROR, getPurchasesErrorHandler);
			Billing.getInstance().addEventListener(BillingEvent.CONSUME_PURCHASE_SUCCESS, consumePurchaseSuccessHandler);
			Billing.getInstance().addEventListener(BillingEvent.CONSUME_PURCHASE_ERROR, consumePurchaseErrorHandler);
			Billing.getInstance().initialize("eyJsaWNlbnNlIjoie1widGltZXN0YW1wXCI6MTQyNDc1MTc5NixcImlkc1wiOltcInJ1Lmthdm9sb3JuLmFuZS5CaWxsaW5nLkRlbW9cIixcImFpci5ydS5rYXZvbG9ybi5hbmUuQmlsbGluZy5EZW1vXCIsXCJydS5rYXZvbG9ybi5hbmUuQmlsbGluZy5EZW1vLmRlYnVnXCIsXCJhaXIucnUua2F2b2xvcm4uYW5lLkJpbGxpbmcuRGVtby5kZWJ1Z1wiXX0iLCJzaWduYXR1cmUiOiJvdEIxMDVmRHZ1ZzZKbjVNVWlCc29hRFBtUVNHdHVlcHdNSFFYRmJYUytiUjdFeVwvTVBqMHBoTGI3cWdBMTNBY0xwejA3ZGx6MFJwTUVWU1paSndIUjlzZVhoTkVGNURtTEZQRktQbmZoQWhJS1g1N3FFRm56clNNTnNmeGFlZjFYMk5oS012VTVsRVFtUDI2S2pTbDllbkNhZjJqV1g1TnV4WmUycWdiR1A4OUpmUElIbEdDZlZzMFE5cTRrY2dzMmo3SEVDdlY0YUZRZUZubDU0RFFlT3dBcFNocUhOMTdsSnUwTzRRTGxhZVVacUY1ODROK1RtRGZZRFZ3THU1cGFmd09hQjh2bTY2eUZCUUNXRlJndjJqXC9nTURxS0Y1NWxjZW52VzQ3azE5YjN6amY0WVArRkJnU1UxV1R4bnJmNkI2aGxQZHpXNjNXdnl2OFFiM0c5Zz09In0=");
		}

		private function initializationSuccessHandler(event:BillingEvent):void
		{
			_label.text += "\nInitialization was successfully completed.";
		}

		private function initializationErrorHandler(event:BillingEvent):void
		{
			_label.text += "\nError occurred during initialization process.";
		}

		private function serviceConnectedHandler(event:BillingEvent):void
		{
			_label.text += "\nService was successfully binded.";
			
			Billing.getInstance().getSkuDetails([
				_productId
			]);
		}

		private function serviceDisconnectedHandler(event:BillingEvent):void
		{
			_label.text += "\nService was disconnected.";
		}

		private function skuDetailsSuccessHandler(event:BillingEvent):void
		{
			_label.text += "\nProducts details received.";
			_label.text += "\n" + event.message;

			Billing.getInstance().getPurchases();
		}

		private function skuDetailsErrorHandler(event:BillingEvent):void
		{
			_label.text += "\nProducts details error.";
		}

		private function purchaseSuccessHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchase completed successfully.";
			_label.text += "\n" + event.message;
		}

		private function purchaseErrorHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchase completed with errors.";
			_label.text += "\n" + event.message;
		}
		
		private function getPurchasesSuccessHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchases received.";
			
			var details:Array = JSON.parse(event.message) as Array;
			for (var i:int = 0; i < details.length; i++)
			{
				trace(JSON.stringify(details));
				
				if (details[i].productId == _productId)
				{
					_label.text += "\nConsuming first.";
					Billing.getInstance().consumePurchase(details[i].purchaseToken);
					return;
				}
			}

			Billing.getInstance().purchase(_productId);
		}

		private function getPurchasesErrorHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchases request failed.";
		}

		private function consumePurchaseSuccessHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchase was consumed.";

			Billing.getInstance().purchase(_productId);
		}

		private function consumePurchaseErrorHandler(event:BillingEvent):void
		{
			_label.text += "\nPurchase was not consumed correctly.";
		}
	}
}
