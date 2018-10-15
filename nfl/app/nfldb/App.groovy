package nfldb

class App {

    static main(String... args) {
        new App() .start(args)
    }

    def start(params) {
        show_prompt()
        def exp
        while (exp = System.console().readLine()) {
            if (exp =~ '\\s*[Qq]quit|[Ee]xit\\s*') {
                println "Bye."
                break
            } else {
            }
            show_prompt()
        }
    }

    def show_prompt() {
        print "Choose action: [quit to exit] "
    }
}
