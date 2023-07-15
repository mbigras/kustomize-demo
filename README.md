# kustomize-demo

> Illustrate how to work with Kustomize overlays and components.

## Summary

You can inherit Kubernetes settings with [_Kustomize bases and overlays_](https://kubectl.docs.kubernetes.io/references/kustomize/glossary/#overlay). But! You can also compose Kubernetes settings with [_Kustomize components_](https://github.com/kubernetes/enhancements/blob/master/keps/sig-cli/1802-kustomize-components/README.md).

## Getting started

The following procedure describes how to deployment _app_ app to a hypothetical _env1_ environment on Docker Desktop on your laptop.

1. Create your Kubernetes cluster on Docker Desktop on your laptop—see [_mbigras/hello-kubernetes_](https://github.com/mbigras/hello-kubernetes) repo.

1. Get the code.

   ```
   git clone git@github.com:mbigras/kustomize-demo.git
   cd kustomize-demo
   ```

1. Run _example.sh_ script.

   ```
   ./example.sh
   ```

   Your output should look like the following:

   ```
   $ ./example.sh
   # ...
   deployment.apps/app created
   # ...
   {
     "app": "app",
     "env": "env1",
     "color": "cheapblue",
     "password": "s3cr3t",
     "features": [
       "feature1",
       "feature2"
     ]
   }
   deployment.apps "app" deleted
   ```

   **Observation:** Notice that you created your app—that is, a _app_ Kubernetes Deployment—, send a test request, and deleted your app!

## Study Kustomize code

The following procedure describes how to create an _app_ Kubernetes Deployment with Kustomize overlays and components.

1. Build your app Kubernetes settings for env1 environment.

   ```
   kustomize build git@github.com:mbigras/kustomize-demo.git//overlays/env1?ref=35b728e6ba9ad874fa6f49985aa5081508fcc52d
   ```

   Your output should look like the following:

   ```
   $ kustomize build git@github.com:mbigras/kustomize-demo.git//overlays/env1?ref=35b728e6ba9ad874fa6f49985aa5081508fcc52d
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     labels:
       app: app
     name: app
   spec:
     selector:
       matchLabels:
         app: app
     template:
       metadata:
         labels:
           app: app
       spec:
         containers:
         - env:
           - name: ENV
             value: env1
           - name: COLOR
             value: cheapblue
           - name: PASSWORD
             value: s3cr3t
           - name: FEATURE2
             value: "on"
           - name: FEATURE1
             value: "on"
           image: mbigras/app:2023-07-15
           name: app
   ```

   Consider the following details:

   1. **Observation:** Notice that the _app_ Deployment contains an _app_ Container that is configured to run in _env1_ environment.
   1. **Note:** You inject settings as environment variables—follows excellent twelve-factor methodology—see https://12factor.net/config page.

1. To understand how the ENV, COLOR, and PASSWORD settings reach app running in env1 environment, consider the [_overlays/env1/kustomization.yaml#L3-L6_](https://github.com/mbigras/kustomize-demo/blob/35b728e6ba9ad874fa6f49985aa5081508fcc52d/overlays/env1/kustomization.yaml#L3-L6) code.

   ```yaml
   kind: Kustomization
   apiVersion: kustomize.config.k8s.io/v1beta1
   resources:
     - ../../base
   patches:
     - path: deployment.yaml
   # ...
   ```

   **Observation:** Notice how your overlay inherits your base, then patches—inheritance.

1. To understand how the FEATURE1 and FEATURE2 settings reach app running in env1 environment, consider the [_overlays/env1/kustomization.yaml#L7-L9_](https://github.com/mbigras/kustomize-demo/blob/35b728e6ba9ad874fa6f49985aa5081508fcc52d/overlays/env1/kustomization.yaml#L7-L9) code.

   ```yaml
   kind: Kustomization
   apiVersion: kustomize.config.k8s.io/v1beta1
   # ...
   components:
     - ../../components/feature1
     - ../../components/feature2
   ```
   **Observation:** Notice how your overlay reaches your components like plug and play composition—excellent!

## Conclusion

You can freely compose Kubernetes YAML objects Kustomize base, overlays, and components. Bases and overlays compose like inheritance. Components compose like plug and play.
