# ABLessons
App for learning languages


I made this app for the [Anton Brejestovski's](https://www.brejestovski.com) English lessons specifically, but it can be used for other lessons as well. 

Lessons are contain texts and exercises. Text is HTML string. Exercise is text to translate, translated text and some helping dictionary (optionally). 
Collections of lessons are stored in Firestore database. Downloaded lessons and student's submissions are stored in the CoreData.

Anton gracefully gave me permission to use his lessons in my app for everybody.
Right now I've uploaded some example lessons through the web interface, but this is temporary solution as I'm working on macOS app for this.

Doing exercises is the main function of this app. 
Student can (and encouraged to) input his answer by the voice. App checks the answer word by word, but student can mark his answer by himself if this check fails.

App remindes to repeat lessons twice: after three and seven days.

![](ABLessons_app.gif =253x450)
