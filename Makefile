# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: fbes <fbes@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2022/07/12 12:49:35 by fbes          #+#    #+#                  #
#    Updated: 2022/07/12 15:57:16 by fbes          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = inception

all: $(NAME)

$(NAME): up

up:
	docker-compose -f srcs/docker-compose.yml up --build

down:
	docker-compose -f srcs/docker-compose.yml down

prune:
	docker system prune -f

clean: down prune
	rm -rf '~/Desktop/Inception'

re: clean all

.PHONY: all $(NAME)
