;; Sixtyfour's website code
;; INDEX w/ FORTUNE
;; ABOUT
;; BLOG

;; GPLv2 only

(ql:quickload '(cl-who parenscript))

(defpackage :sixtyfour
  (:use :cl :cl-who :parenscript))

(in-package :sixtyfour)

(setq cl-who:*attribute-quote-char* #\")
(defvar *blog-entry-list* '(("Tonari no Kyuuketsuki-san" . "tonari-no-kyuuketsuki-san.htm")
							("Void on a Stick" . "void-on-a-stick.htm")))

(defmacro standard-page-bare ((&key title) &body body)
  "Bare page macro. Used by Index."
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
             (:img :src "https://count.getloli.com/get/@:64?theme=gelbooru"
                   :width "400"
                   :style "padding-bottom: 20px")
				   (:div :id "row"
						 (:img :src "img/warn.png"
							   :height "31"
							   :class "badge")
						 (:img :src "img/sink.png"
							   :height "31"
									 :class "badge")
						 (:img :src "img/gnubanner.gif"
									 :height "31"
									 :class "badge")
						 (:img :src "img/js.gif"
									 :height "31"
									 :class "badge")
						 (:img :src "img/konata.gif"
									 :height "31"
									 :class "badge"))
				   (:div :id "row"
						 (:img :src "img/miku.gif"
									 :height "31"
									 :class "badge")
						 (:img :src "img/pothead.gif"
									 :height "31"
									 :class "badge")
						 (:img :src "img/rorikon.gif"
									 :height "31"
									 :class "badge")
						 (:img :src "img/copyleft.svg"
							   :height "31"
							   :class "badge")))))))

(defmacro standard-page ((&key title) (&key links) &body body)
  "Creates page with links at the bottom."
  `(standard-page-bare (:title ,title)
					   ,@body
					   (:br)
					   (loop for (title . link) in ,links
							 do (htm
								 (:h2 "("
									  (:a :href link
										  (:b (str title)))
									  ")")
								 ))
					   (:h2 "("
							(:a :href "index.htm"
								"Home")
							")")))

(defmacro standard-page-main ((&key title) &body body)
  "Main page. Used by Blog, About."
  `(standard-page (:title ,title) (:links '()) ,@body))

(defmacro standard-page-blog ((&key title) &body body)
  "Blog page, with link to Blog."
  `(standard-page (:title ,title) (:links '(("Blog" . "blog.htm"))) ,@body))

(defmacro define-page ((name) &body body)
  "Writes HTML data to a .htm file."
  `(with-open-file (stream ,(concatenate 'string name ".htm") :direction :output :if-exists :supersede :if-does-not-exist :create)
	 (format stream "~a" ,@body)))

(defmacro read-blog (name)
  "Reads a simple org file and turns it into a blog entry. Limitations: Only one link per line, 2 layers of nested headings."
  `(with-open-file (entry-text ,(concatenate 'string name ".org") :direction :input)
	 (let ((title (subseq (read-line entry-text) 8)))
	   (nconc *blog-entry-list* (list (cons title ,(concatenate 'string name ".htm"))))
	   (define-page (,name)
		   (standard-page-blog (:title (str title))
							   (:img :src (remove #\[ (remove #\] (read-line entry-text)))
									 :class "logo")
							   (loop for line = (read-line entry-text nil)
									 while line do (if (eql (length line) 0) (htm (:p ""))
													   (if (eql (elt line 0) #\*)
														   (if (eql (elt line 1) #\*)
															   (htm (:h2 (str (subseq line 3))))
															   (htm (:h1 (str (subseq line 2)))))
														   (let ((link-loc nil) (link-end nil) (link-mid nil))
															 (loop for idex from 0 to (- (length line) 1)
																   do (cond ((and (eql (elt line idex) #\[)
																				  (not link-loc)) (setq link-loc idex))
																			((and (eql (elt line idex) #\])
																				  (not link-mid)) (setq link-mid idex))
																			((eql (elt line idex) #\]) (setq link-end idex))))
															 (if link-loc			
																 (htm (:p (str (subseq line 0 link-loc))
																		  (:a :href (subseq line (+ link-loc 2) link-mid)
																			  (:b (str (subseq line (+ link-mid 2) (1- link-end)))))
																		  (str (subseq line (1+ link-end)))))
																 (htm (:p (str line)))))))))))))

;; HTML blog entries, legacy stuff

(define-page ("tonari-no-kyuuketsuki-san")
	(standard-page-blog (:title "Tonari no Kyuuketsuki-san")
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

(define-page ("void-on-a-stick")
	(standard-page-blog (:title "Void on a Stick")
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

;; Cool new .org blog entries!
;; Make sure read-blog is used before the blog file is created.

(read-blog "lisp-web-experience")

;; Index, About and Blog.

(define-page ("index")
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
						(:br)
						(:h4 "Hit refresh for more backgrounds!")))

(define-page ("about")
	(standard-page-main (:title "About")
						(:img :src "img/erica.jpg"
							  :class "logo")
						(:h1 "About me")
						(:p "I write Lisp code.")
						(:h1 "Contact")
						(loop for (title . link) in '(("Email" . "mailto:twotothepowersix@gmail.com")
													  ("Discord" . "mailto:64#7312")
													  ("Github" . "https://github.com/strikewizard/"))
							  do (htm
								  (:p
								   (:a :href link
									   (:b (str title)))
								   :br)))))

(define-page ("blog")
	(standard-page-main (:title "Blog")
						(:img :src "img/freedom.jpg")
						(:h1 "Entries")
						(loop for (title . link) in *blog-entry-list*
							  do (htm
								  (:p
								   (:a :href link
									   (:i
										(:b (str title))))
								   :br)))))
