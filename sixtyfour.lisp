;; Sixtyfour's website code
;; INDEX w/ FORTUNE
;; ABOUT
;; BLOG

;; GPLv2 only

(defpackage :sixtyfour
  (:use :cl :cl-who :parenscript))

(in-package :sixtyfour)

(setq cl-who:*attribute-quote-char* #\")

(defmacro standard-page ((&key title) &body body)
  `(standard-page-bare (:title ,title)
					   ,@body
					   (:br)
					   (:h2 "("
							(:a :href "index.htm"
								"Home")
							")")))

(defmacro standard-page-bare ((&key title) &body body)
  `(with-html-output-to-string (stream)
	 (:html :xmlns "https://www.w3.org/1999/xhtml"
			:xml\:lang "en"
			:lang "en"
			(:head
			 (:meta :http-equiv "Content-Type"
					:content "text/html;charset=utf-8")
			 (:link :rel "icon"
					:href "img/lisp.png")
			 (:title ,title)
			 (:link :type "text/css"
					:rel "stylesheet"
					:href "css/sixtyfour.css"))
			(:script :type "text/javascript"
					 (str (ps
					 (var total-count 123)
					 (defun change-it ()
					   (var num (random total-count))
					   (setf (@ document body background)
							 (+ "tile/" num ".gif")))
					 (defun fortune-face ()
					   (var num (random 16))
					   (setf (@ document
								face
								src)
							 (+ "faces/" num ".png"))
					   t)
					 (defun fortune ()
					   (var fortunes
							(array "EXCELLENT" "CRINGE" "BORING" "POGGERS" "BASED"))
					   (var num (random 5))
					   (elt fortunes num)))))
			(:body
			  (:script :type "text/javascript"
								(str (ps (change-it))))
			 ,@body
			 (:br)
			 (:div :id "footer"
				   (:div :id "row"
						 (:img :src "img/warn.png"
							   :height "64"
							   :class "logo")
						 (:img :src "img/sink.png"
							   :height "64"
							   :class "logo")
						 (:img :src "img/copyleft.svg"
							   :height "64"
							   :class "logo")))))))

(defmacro define-url-fn ((name) &body body)
  `(with-open-file (stream ,(concatenate 'string name ".htm") :direction :output :if-exists :overwrite :if-does-not-exist :create)
	(format stream "~a" ,@body)))

(define-url-fn ("about")
	(standard-page (:title "About")
				   (:img :src "img/erica.jpg"
						 :class "logo")
				   (:h1 "About me")
				   (:p "I write Lisp code.")
				   (:h1 "Contact")
				   (loop for (title . link) in '(("Email" . "mailto:twotothepowersix@gmail.com")
												 ("Discord" . "64#7312")
												 ("Github" . "https://github.com/strikewizard/"))
						 do (htm
							 (:p
							  (:a :href link
								  (:b (str title)))
							  :br)))))

(define-url-fn ("blog")
	(standard-page (:title "Blog")
				   (:img :src "img/freedom.jpg")
				   (:h1 "Entries")
				   (loop for (title . link) in '(("Tonari no Kyuuketsuki-san" . "tonari-no-kyuuketsuki-san.htm")
												 ("Void on a Stick" . "void-on-a-stick.htm"))
						 do (htm
							 (:p
							  (:a :href link
								  (:i
									(:b (str title))))
							  :br)))))

(define-url-fn ("tonari-no-kyuuketsuki-san")
			   (standard-page (:title "Tonari no Kyuuketsuki-san")
							  (:h1 "Tonari no Kyuuketsuki-san")
							  (:h2 "CGDCT with the Vampire")
							  (:h2 "Verdict: Fun.")
							  (:p "Tonari no Kyuuketsuki-san is an excellent CGDCT anime that's best watched weekly.")
							  (:p "It's adapted from a 4koma manga by the same name, and features 4 main characters with 3 supporting characters. The plot follows a schoolgirl named Akari who loves collecting dolls. She visits the woods near her town when she hears rumors of a house with a living doll in the woods, and encounters our deuteragonist: Sophie, who is a Vampire. Entranced by her doll-like appearance, Akari quickly befriends Sophie, and eventually ends up living with her.")
							  (:p "Each episode contains 3 stories, which are mostly episodic in nature barring character introductions.")
							  (:h2 "Fanservice")
							  (:p "Okay, not much but definitely present")
							  (:h2 "Music")
							  (:p "The ED is a banger, and the OP is pretty good too.")
							  (:p "The OST wasn't anything special, but it stood out of the way and fit the relaxed atmosphere of the show.")
							  (:img :src "img/tonari.png")))

(define-url-fn ("void-on-a-stick")
			   (standard-page (:title "Void on a Stick")
			   (:h1 "Void on a Stick")
			   (:p "I recently created a persistent Void Linux USB Stick.
				   The procedure is as follows:
				   ")
				   (:ul
				  (:li "Get a Void Linux ISO")
				  (:li "Use your favorite USB burner and create a LiveCD with "
					   (:b "persistence cranked all the way up"))
				  (:li "Plug the LiveCD in, and install Void onto the "
					   (:b "persistent sector on the USB"))
				  (:li "Check if you're able to boot into and use Void")
				  (:li "If it works, boot into the GNU/Linux OS already installed onto your computer")
				  (:li "Plug-in the USB")
				  (:li "Install " (:b "gparted"))
				  (:li "Use gparted to wipe the LiveCD's partition off the USB")
				  (:li "Grow the persistent partition to occupy the entire USB")
				  (:li "Boot into Void to check if everything works"))
				(:h2 "There you have it! Void on a Stick!")
				(:img :src "img/void.svg")))

;; INDEX PAGE

(define-url-fn ("index")
	(standard-page-bare (:title "Sixtyfour's Website")
						(:div :id "header"
							  (:img :src "img/yoshika.png"
									:class "logo"))
						(:h1 "Sixtyfour's Website")
						(:p (:i "Now with 100% more eyerape."))
						(loop for (title . link) in '(("About" . "about.htm")
													  ("Blog" . "blog.htm"))
							  do (htm
								  (:p
				 				   (:a :href link
									   (:b (str title)))
								   :br)))
						(:h2 "Today's Fortune: ")
						(:h3
						(:script :type "text/javascript"
								(str (ps-inline (chain document
													   (write (fortune)))))))
						(:img :name "face"
							  :src nil
							  :class "logo")
						(:script :type "text/javascript"
								 (str (ps-inline (fortune-face))))
						(:br)))
