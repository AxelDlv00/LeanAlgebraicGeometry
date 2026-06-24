# Notices

- **Scope = paper §1 only** (base-change theory); §§2–8 deferred. §1 rests on `External.*`
  EGA/OB/Stacks axioms (foundations absent from Mathlib v4.30.0; all paper-cited, buildable/upstreamable) —
  **11, plus 2 added this iter for Thm 1.2 (13 total).** `archon-protected.yaml` is still the empty
  template — listing them there silences the doctor's per-iter axiom flag. Broaden scope or request an
  axiom *built* axiom-clean via `USER_HINTS.md`.
- **iter-022: Thm 1.2 `exists_acyclic_surjection` is being closed by anchor-and-assemble** (the route that
  closed 1.4). The 3-iter bottom-up `j_!`-exactness build (019–021) confirmed a from-scratch multi-iter
  absent-Mathlib layer (no pointwise Lan formula for the partial-adjoint presheaf pullback; no derivability
  data for the Ext-adjunction). Per the `affine_fp_tilde` precedent the loop pivoted: it anchors the **2
  general facts AK invoke without proof** in the 1.2 proof (surjection existence + acyclicity of the
  extension-by-zero coproduct's pullback; both verbatim-sourced) and assembles 1.2. Steer build-vs-anchor or
  scope via `USER_HINTS.md`; no reply needed — the loop keeps moving.
