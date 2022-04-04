tailscale-shell: tailscale-image
	docker run -it --rm --entrypoint="/bin/bash" tailscale-ingress-controller:latest

tailscale-image:
	docker buildx build . \
	-f ./tailscale.dockerfile \
	-t tailscale-ingress-controller:latest

push: tailscale-image
	docker tag tailscale-ingress-controller:latest 127.0.0.1:15555/tailscale-ingress-controller:latest
	docker push 127.0.0.1:15555/tailscale-ingress-controller:latest

deploy:
	helm upgrade -i tailscale-ingress-controller ./charts/tailscale-ingress-controller -n tailscale -f ./dev.yaml
	kubectl rollout restart deployment tailscale-ingress-controller-ingress-nginx-controller -n tailscale