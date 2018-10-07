package nfldb

class Main {

    static main(String... args) {
        new Main() .start(args)
    }

    def start(String... args) {
        show_prompt()
        def exp
        while (exp = System.console().readLine()) {
            if (exp =~ '\\s*[Yy]\\s*') {
                println "Shooting..."
            } else {
                println "Bye."
                break
            }
            show_prompt()
        }
    }

    def show_prompt() {
        //println "Bullet in $gun.loaded"
        print "Shoot? [y/N] "
    }
}
