(define ssh_args '("-i" 
                   "/var/lib/jenkins/.jenkins/jobs/vagrant_arch/workspace/archlinux/vagrantfiles/headless/.vagrant/machines/default/virtualbox/private_key" 
                   "-p" 
                   "2222" 
                   "-T" 
                   "vagrant@localhost"))

(define (run_command_on_host command)
  (let
    ((ssh_command "/usr/bin/ssh")
     (args (append ssh_args command)))
    (apply subprocess #f #f #f ssh_command args)))

(define (run_command command)
  (let-values
    ([(sp stdout stdin stderr) (run_command_on_host command)])
    (read-line stdout)))
