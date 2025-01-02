B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private BANano As BANano 'ignore
	Private X() As Int
	Private Y() As Int
End Sub

' add in Main.AppStart
' <code>BANano.Header.AddJavascriptFile("https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@latest/dist/tf.min.js") </code>
'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(mBANano As BANano)
	BANano=mBANano
	'SDfunc.MainLayout.Append("<script>const model = tf.sequential();</script>")
End Sub

Public Sub SetDataX(xData() As Int)
	X=xData
End Sub

Public Sub SetDataY(yData() As Int)
	Y=yData
End Sub

Public Sub Predict(IDelement As String)	
	BANano.RunInlineJavascriptMethod("predict", Array(X,X.Length,Y,Y.Length,IDelement))
End Sub


#IF Javascript
function predict(xx, nx , yy , ny, idel) {
	document.getElementById(idel).innerText = 'wait ..';
	const model = tf.sequential();
    model.add(tf.layers.dense({ units: 64, activation: 'relu', inputShape: [1] }));
    //model.add(tf.layers.dense({ units: 32, activation: 'relu'}));
    model.add(tf.layers.dense({units: 1, inputShape: [1]}));

    model.compile({loss: 'meanSquaredError', optimizer: 'adam'});

    // Generate some synthetic data for training.
    // Training data with 20 values excluding 7
    //const xs = tf.tensor2d([1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,22], [21, 1]);
    //const ys = tf.tensor2d([1, 4, 9, 16, 25, 36, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400, 441, 484], [21, 1]);
	const xs = tf.tensor2d(xx, [nx, 1]);
    const ys = tf.tensor2d(yy, [ny, 1]);

    // Train the model using the data.
    model.fit(xs, ys, {epochs: 350}).then(() => {
      // Use the model to do inference on a data point the model hasn't seen before:
      //model.predict(tf.tensor2d([5], [1, 1])).print();

      // Open the browser devtools to see the output
      document.getElementById(idel).innerText =  'Predict: ' + model.predict(tf.tensor2d([7], [1, 1])).dataSync()[0];
    });
    return value;
}
#End If
