---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:section_base_change_injective_cover
lean_status: lean_ok
order: 1224
title: Injectivity along a finite cover, by flat base change
type: tex
updated: '2026-07-27T20:11:17'
---
Let \(A \to B\) be a flat homomorphism of commutative rings, let \(M\) be
  an \(A\)-module and \(P\) a \(B\)-module, and let \((M_i)_{i \in \iota}\),
  \((P_i)_{i \in \iota}\) be finite families of modules with \(A\)-linear
  maps \(\mathrm{res}_i : M \to M_i\) jointly injective and \(B\)-linear
  maps \(\mathrm{res}'_i : P \to P_i\). Suppose \(s : B \otimes_A M \to P\)
  is \(B\)-linear and, for each \(i\), there is an injective \(B\)-linear
  comparison \(\varepsilon_i : B \otimes_A M_i \to P_i\) with
  \(\mathrm{res}'_i(s(1 \otimes m)) = \varepsilon_i(1 \otimes
  \mathrm{res}_i(m))\) for all \(m \in M\). Then \(s\) is injective.