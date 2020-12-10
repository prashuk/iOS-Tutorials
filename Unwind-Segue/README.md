# Unwind Segues

Let’s say we have three screens — 1,2 and 3. We want to move from 1 to 2 by creating a **Show** segue and now move to 3 from 2 by using a **Present Modally** segue in the Storyboard.

We just created a **Present Modally** segue from 2 and 3— this means if we want to go back to 2 from 3, we can simply dismiss the present view controller(VC3) by using this method:

```
@IBAction func dismissVC(_ sender: Any) {     
		dismiss(animated: true, completion: nil)
}
```

But what if we want to go back to 1, not 2, from 3?

Follow these simple **four steps** to create Unwind segues:

1. In the view controller you are trying to go back ***to\***, **VC1** in my example, write this code:

```
@IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
```

2. In the Storyboard, go to the screen you’re trying to unwind ***from ( 3\*** *in our case* ***)\***, and control + drag the view controller icon to the Exit icon located on top.

   When you are presented with IBAction option(s) to connect to, select the unwind segue action you just created in VC1.

3. Go to the document outline of the selected view controller in the Storyboard, select the unwind segue as shown below.

4. Select the Unwind segue in the document outline

   Now, go to the Attributes Inspector in the Utilities Pane and name the identifier of the unwind segue.

![img](https://miro.medium.com/max/60/1*8KalrmczmxN3ZlX0KvHCfw.png?q=20)

![img](https://miro.medium.com/max/514/1*8KalrmczmxN3ZlX0KvHCfw.png)

5. Specify the identifier of the Unwind segue

6. Finally, write this code where you want the unwind segue action to be triggered, V3 in our case.

```
@IBAction func goBackToOneButtonTapped(_ sender: Any) {     
		performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
}
```

