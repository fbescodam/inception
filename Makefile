# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: fbes <fbes@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/07/12 12:49:35 by fbes          #+#    #+#                  #
#    Updated: 2022/09/08 16:48:52 by fbes          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = inception

COMPOSE_YML = srcs/docker-compose.yml

all: $(NAME)

$(NAME): up

up:
	mkdir -p $(HOME)/data/db
	mkdir -p $(HOME)/data/www
	docker-compose -f $(COMPOSE_YML) up --build --remove-orphans

down:
	docker-compose -f $(COMPOSE_YML) down

prune:
	docker-compose -f $(COMPOSE_YML) down --rmi all -v --remove-orphans
	docker system prune --force --volumes

clean: prune
	rm -rf '~/data'

re: clean all

.PHONY: all $(NAME)
