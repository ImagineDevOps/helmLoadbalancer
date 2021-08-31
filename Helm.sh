Note: It’s advised you consult the Rancher Support Matrix to get the recommended version for all Rancher dependencies.

https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/#1-install-the-required-cli-tools

kubectl

</pre><td class="rouge-code"><pre>helm <span class="nb">install</span> <span class="se">\</span>
  cert-manager jetstack/cert-manager <span class="se">\</span>
  <span class="nt">--namespace</span> cert-manager <span class="se">\</span>
  <span class="nt">--version</span> v1.2.0
</pre></table></code></div></div><p>check rollout of cert-manager</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>kubectl get pods <span class="nt">--namespace</span> cert-manager
</pre></table></code></div></div><p>Be sure each pod is fully running before proceeding</p><p>Install Rancher with Helm</p><p><em>Note:If you have “.local” for your private TLD then Rancher will NOT finish the setup within the webUI</em></p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
2
3
</pre><td class="rouge-code"><pre>helm <span class="nb">install </span>rancher rancher-stable/rancher <span class="se">\</span>
  <span class="nt">--namespace</span> cattle-system <span class="se">\</span>
  <span class="nt">--set</span> <span class="nb">hostname</span><span class="o">=</span>rancher.example.com
</pre></table></code></div></div><p>check rollout</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>kubectl <span class="nt">-n</span> cattle-system rollout status deploy/rancher
</pre></table></code></div></div><p>you should see</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
2
3
4
</pre><td class="rouge-code"><pre>Waiting <span class="k">for </span>deployment <span class="s2">"rancher"</span> rollout to finish: 0 of 3 updated replicas are available...
Waiting <span class="k">for </span>deployment <span class="s2">"rancher"</span> rollout to finish: 1 of 3 updated replicas are available...
Waiting <span class="k">for </span>deployment <span class="s2">"rancher"</span> rollout to finish: 2 of 3 updated replicas are available...
deployment <span class="s2">"rancher"</span> successfully rolled out
</pre></table></code></div></div><p>check status</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>kubectl <span class="nt">-n</span> cattle-system rollout status deploy/rancher
</pre></table></code></div></div><p>you should see</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>deployment <span class="s2">"rancher"</span> successfully rolled out
</pre></table></code></div></div><h2 id="load-balancer">load balancer</h2><p>If you are using <code class="language-plaintext highlighter-rouge">k3s</code> you can use the <code class="language-plaintext highlighter-rouge">traefik</code> ingress controller that ships with <code class="language-plaintext highlighter-rouge">k3s</code></p><p>run</p><div class="language-bash highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>kubectl get svc <span class="nt">--all-namespaces</span> <span class="nt">-o</span> wide
</pre></table></code></div></div><p>look for</p><div class="language-plaintext highlighter-rouge"><div class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
</pre><td class="rouge-code"><pre>kube-system     traefik                LoadBalancer   10.43.202.72   192.168.100.10   80:32003/TCP,443:32532/TCP   5d23h   app=traefik,release=traefik
</pre></table></code></div></div><p>then create a DNS entry for <code class="language-plaintext highlighter-rouge">rancher.example.com 192.168.100.10</code></p><p>This can be a host entry on your machine, or a DNS entry in your local DNS system (router, pi hole, etc…)</p><p>otherwise you can use <code class="language-plaintext highlighter-rouge">nginx</code></p><p>nginx lb</p><p><a href="https://rancher.com/docs/rancher/v2.x/en/installation/resources/k8s-tutorials/infrastructure-tutorials/nginx/">https://rancher.com/docs/rancher/v2.x/en/installation/resources/k8s-tutorials/infrastructure-tutorials/nginx/</a></p><h2 id="other-considerations">other considerations</h2><p>Separating Rancher Cluster from your User Cluster</p><p><a href="https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/#separation-of-rancher-and-user-clusters">https://rancher.com/docs/rancher/v2.x/en/overview/architecture-recommendations/#separation-of-rancher-and-user-clusters</a></p></div><div class="post-tail-wrapper text-muted"><div class="post-meta mb-3"> <i class="far fa-folder-open fa-fw mr-1"></i> <a href='/categories/kubernetes/'>kubernetes</a>, <a href='/categories/rancher/'>rancher</a></div><div class="post-tags"> <i class="fa fa-tags fa-fw mr-1"></i> <a href="/tags/homelab/" class="post-tag no-text-decoration" >homelab</a> <a href="/tags/rancher/" class="post-tag no-text-decoration" >rancher</a> <a href="/tags/kubernetes/" class="post-tag no-text-decoration" >kubernetes</a> <a href="/tags/k3s/" class="post-tag no-text-decoration" >k3s</a></div><div class="post-tail-bottom d-flex justify-content-between align-items-center mt-3 pt-5 pb-2"><div class="license-wrapper"> This post is licensed under <a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a> by the author.</div><div class="share-wrapper"> <span class="share-label text-muted mr-1">Share</span> <span class="share-icons"> <a href="https://twitter.com/intent/tweet?text=High Availability Rancher on kubernetes - Techno Tim&url=https://techno-tim.github.io/posts/rancher-ha-install/" data-toggle="tooltip" data-placement="top" title="Twitter" target="_blank" rel="noopener" aria-label="Twitter"> <i class="fa-fw fab fa-twitter"></i> </a> <a href="https://www.facebook.com/sharer/sharer.php?title=High Availability Rancher on kubernetes - Techno Tim&u=https://techno-tim.github.io/posts/rancher-ha-install/" data-toggle="tooltip" data-placement="top" title="Facebook" target="_blank" rel="noopener" aria-label="Facebook"> <i class="fa-fw fab fa-facebook-square"></i> </a> <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://techno-tim.github.io/posts/rancher-ha-install/" data-toggle="tooltip" data-placement="top" title="Linkedin" target="_blank" rel="noopener" aria-label="Linkedin"> <i class="fa-fw fab fa-linkedin"></i> </a> <i class="fa-fw fas fa-link small" onclick="copyLink()" data-toggle="tooltip" data-placement="top" title="Copy link"></i> </span></div></div></div></div></div><div id="panel-wrapper" class="col-xl-3 pl-2 text-muted topbar-down"><div class="access"><div id="access-lastmod" class="post"> <span>Recent Update</span><ul class="post-content pl-0 pb-1 ml-1 mt-2"><li><a href="/posts/k3s-traefik-rancher/">Traefik 2, k3s, Rancher</a><li><a href="/posts/first-11-things-proxmox/">Before I do anything on Proxmox, I do this first...</a><li><a href="/posts/open-source-linktree-alt/">Self-Hosted, DIY, Open Source Alternative to Linktree</a><li><a href="/posts/traefik-portainer-ssl/">Put Wildcard Certificates and SSL on EVERYTHING</a><li><a href="/posts/proxmox-7/">Before you upgrade to Proxmox 7, please consider this...</a></ul></div><div id="access-tags"> <span>Trending Tags</span><div class="d-flex flex-wrap mt-3 mb-1 mr-3"> <a class="post-tag" href="/tags/homelab/">homelab</a> <a class="post-tag" href="/tags/kubernetes/">kubernetes</a> <a class="post-tag" href="/tags/rancher/">rancher</a> <a class="post-tag" href="/tags/docker/">docker</a> <a class="post-tag" href="/tags/portainer/">portainer</a> <a class="post-tag" href="/tags/self-hosted/">self-hosted</a> <a class="post-tag" href="/tags/hardware/">hardware</a> <a class="post-tag" href="/tags/proxmox/">proxmox</a> <a class="post-tag" href="/tags/windows/">windows</a> <a class="post-tag" href="/tags/linux/">linux</a></div></div></div><script src="https://cdn.jsdelivr.net/gh/afeld/bootstrap-toc@1.0.1/dist/bootstrap-toc.min.js"></script><div id="toc-wrapper" class="pl-0 pr-4 mb-5"> <span class="pl-3 pt-2 mb-2">Contents</span><nav id="toc" data-toggle="toc"></nav></div></div></div><div class="row"><div class="col-12 col-lg-11 col-xl-8"><div id="post-extend-wrapper" class="pl-1 pr-1 pl-sm-2 pr-sm-2 pl-md-4 pr-md-4"><div id="related-posts" class="mt-5 mb-2 mb-sm-4"><h3 class="pt-2 mt-1 mb-4 ml-1" data-toc-skip>Further Reading</h3><div class="card-deck mb-4"><div class="card"> <a href="/posts/k3s-traefik-rancher/"><div class="card-body"> <span class="timeago small" > Apr 8 <i class="unloaded">2021-04-08T09:00:00-05:00</i> </span><h3 class="pt-0 mt-1 mb-3" data-toc-skip>Traefik 2, k3s, Rancher</h3><div class="text-muted small"><p> Traefik 2, k3s, Rancher About No video currently exists for this (yet) This guide is for installing traefik 2 on k3s It assumes you have followed: HIGH AVAILABILITY k3s (Kubernetes) in ...</p></div></div></a></div><div class="card"> <a href="/posts/rancher-monitoring/"><div class="card-body"> <span class="timeago small" > Apr 10 <i class="unloaded">2021-04-10T09:00:00-05:00</i> </span><h3 class="pt-0 mt-1 mb-3" data-toc-skip>Monitoring Your Kubernetes Cluster with Grafana, Prometheus, and Alertmanager</h3><div class="text-muted small"><p> Today in this step by step guide, we’ll set up Grafana, Prometheus, and Alertmanager to monitor your Kubernetes cluster. This can be set up really quickly using helm or the Rancher UI. We’ll in...</p></div></div></a></div><div class="card"> <a href="/posts/longhorn-install/"><div class="card-body"> <span class="timeago small" > Jan 2 <i class="unloaded">2021-01-02T08:00:00-06:00</i> </span><h3 class="pt-0 mt-1 mb-3" data-toc-skip>Cloud Native Distributed Storage in Kubernetes with Longhorn</h3><div class="text-muted small"><p> Storage in Kubernetes is hard, complicated, and messy. Configuring volumes, mounts, and persistent volumes claims and getting it right can be a challenge. It’s also challenging to manage that s...</p></div></div></a></div></div></div><div class="post-navigation d-flex justify-content-between"> <a href="/posts/ha-pi-hold-gravity-sync/" class="btn btn-outline-primary" prompt="Older"><p>High Availability Pi-Hole? Yes please!</p></a> <a href="/posts/k3s-ha-install/" class="btn btn-outline-primary" prompt="Newer"><p>HIGH AVAILABILITY k3s (Kubernetes) in minutes!</p></a></div></div></div></div><script type="text/javascript" src="https://cdn.jsdelivr.net/npm/lozad/dist/lozad.min.js"></script> <script type="text/javascript"> const imgs = document.querySelectorAll('.post-content img'); const observer = lozad(imgs); observer.observe(); </script><footer class="d-flex w-100 justify-content-center"><div class="d-flex justify-content-between align-items-center"><div class="footer-left"><p class="mb-0"> © 2021 <a href="https://twitter.com/technotimlive">Techno Tim</a>. <span data-toggle="tooltip" data-placement="top" title="Except where otherwise noted, the blog posts on this site are licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License by the author.">Some rights reserved.</span></p></div></div></footer></div><div id="search-result-wrapper" class="d-flex justify-content-center unloaded"><div class="col-12 col-sm-11 post-content"><div id="search-hints"><h4 class="text-muted mb-4">Trending Tags</h4><a class="post-tag" href="/tags/homelab/">homelab</a> <a class="post-tag" href="/tags/kubernetes/">kubernetes</a> <a class="post-tag" href="/tags/rancher/">rancher</a> <a class="post-tag" href="/tags/docker/">docker</a> <a class="post-tag" href="/tags/portainer/">portainer</a> <a class="post-tag" href="/tags/self-hosted/">self hosted</a> <a class="post-tag" href="/tags/hardware/">hardware</a> <a class="post-tag" href="/tags/proxmox/">proxmox</a> <a class="post-tag" href="/tags/windows/">windows</a> <a class="post-tag" href="/tags/linux/">linux</a></div><div id="search-results" class="d-flex flex-wrap justify-content-center text-muted mt-3"></div></div></div></div><div id="mask"></div><a id="back-to-top" href="#" aria-label="back-to-top" class="btn btn-lg btn-box-shadow" role="button"> <i class="fas fa-angle-up"></i> </a> <script src="https://cdn.jsdelivr.net/npm/simple-jekyll-search@1.7.3/dest/simple-jekyll-search.min.js"></script> <script> SimpleJekyllSearch({ searchInput: document.getElementById('search-input'), resultsContainer: document.getElementById('search-results'), json: '/assets/js/data/search.json', searchResultTemplate: '<div class="pl-1 pr-1 pl-sm-2 pr-sm-2 pl-lg-4 pr-lg-4 pl-xl-0 pr-xl-0"> <a href="https://techno-tim.github.io{url}">{title}</a><div class="post-meta d-flex flex-column flex-sm-row text-muted mt-1 mb-1"> {categories} {tags}</div><p>{snippet}</p></div>', noResultsText: '<p class="mt-5">Oops! No result founds.</p>', templateMiddleware: function(prop, value, template) { if (prop === 'categories') { if (value === '') { return `${value}`; } else { return `<div class="mr-sm-4"><i class="far fa-folder fa-fw"></i>${value}</div>`; } } if (prop === 'tags') { if (value === '') { return `${value}`; } else { return `<div><i class="fa fa-tag fa-fw"></i>${value}</div>`; } } } }); </script>

