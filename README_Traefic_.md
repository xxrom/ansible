`kk get pods,svc -n kube-system | grep traefik` - get info and port for traefik ...
`... 80:30913/TCP,443:30766/TCP   30d` -> port 30913, it's random all the time ....................

---

`kubectl edit deployment traefik -n kube-system` - scale traefic to use 2 replicas instead of 1

```
spec:  replicas: 2
```

---
