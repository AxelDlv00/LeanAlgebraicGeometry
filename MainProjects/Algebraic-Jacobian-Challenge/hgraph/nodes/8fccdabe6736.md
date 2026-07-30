---
author: sync
content_type: theorem
created: '2026-07-30T11:05:08'
decl: Pr.twistIso_w
docstring: Semilinearity square for the ISO -- still Over.w, so still free.
file: probe_p4_iso.lean
generated: lean
lean_status: lean_ok
stale: true
title: Pr.twistIso_w
type: lean
updated: '2026-07-31T02:29:53'
---
theorem twistIso_w (γ : k' ≃ₐ[k] k') :
    (twistIso C rep γ).hom.left ≫ X'.hom
      = X'.hom ≫ (toSpecAut (k' ≃ₐ[k] k') k' γ).hom :=
  Over.w (twistIso C rep γ).hom