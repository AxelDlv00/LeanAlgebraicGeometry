Target chapter: blueprint/src/chapters/Cohomology_FlatBaseChange.tex (covers FlatBaseChange.lean
+ FlatBaseChangeGlobal.lean). Write ONLY this chapter (+ references/** if a retriever is needed).

Action: ADD a new section "FBC-B: the global $H^0$ flat-base-change isomorphism via the finite
affine-cover equalizer (direct route)" near the END of the chapter (after the affine-case
sections). Do NOT delete or rewrite the existing affine/mate-route sections — they remain
formalized; this section documents the SEPARATE, now-primary route to the named global target.

Mathematical content (Stacks 02KH part 2, degree 0). The route does NOT use the
adjoint-mate keystone `_legs_conj`; it assembles the global iso directly:
1. Already FORMALIZED in FlatBaseChangeGlobal.lean (0 sorries) — blueprint these as blocks with
   accurate `\lean{}` + `\uses{}`:
   - `Scheme.exists_finite_affineCover_inter_isQuasiCompact` — a qcqs scheme has a FINITE affine
     cover with quasi-compact pairwise overlaps.
   - `Modules.gammaTopEquivEqLocus` — global sections `Γ(X,M)` over the ground ring `A=Γ(X,⊤)`
     are the `LinearMap.eqLocus` of the two restriction legs `leftRes ⇉ rightRes` on a cover
     (sheaf separatedness + gluing on the underlying `Ab`-sheaf).
   - `Modules.baseChangeGammaEquiv` — for flat `A`-algebra `B`, `B ⊗_A Γ(X,M) ≅ eqLocus(B⊗leftRes,
     B⊗rightRes)`, i.e. flat base change COMMUTES with the finite `H⁰` equalizer
     (`LinearMap.tensorEqLocusEquiv`). THIS is the module-level core.
2. REMAINING obligation (the new prover work this section scopes): identify the right-hand
   base-changed equalizer with the global sections of the pulled-back module `g'^*F` over `X'`,
   per chart via the affine module base change `F(U_i)⊗_A B = (g'^*F)(U'_i)` (Stacks tag 01I9,
   already DONE as `lem:pullback_spec_tilde_iso` / `regroupEquiv` in this chapter), then assemble
   into the named global iso `thm:flat_base_change_pushforward`
   (`g^* f_* F ⟶ f'_* g'^* F` is an isomorphism). State this assembly as a theorem block with a
   complete informal proof and an explicit `\uses{}` listing the three Lean-done blocks above +
   the affine module base change.

Citations: read references/stacks-coherent.tex (tag 02KH, part 2 — the H⁰ base-change statement)
and references/stacks-schemes.tex (tag 01I9 — `ψ^* M̃ = (S⊗_R M)~`). Add `% SOURCE:` /
`% SOURCE QUOTE:` / `\textit{Source:}` per the citation rules, verbatim from those local files.

Strategy framing for the prose (1–2 sentences, no Lean): this route is "Čech-cohomology-free"
— `H⁰` is a finite limit (equalizer), and flat `−⊗B` preserves finite limits, so the global iso
follows from per-chart affine base change WITHOUT the abstract conjugate/mate identification.

Constraints: NO `\leanok` markers (sync_leanok owns them). You MAY mark `\mathlibok` ONLY on a
genuine Mathlib anchor (e.g. `LinearMap.tensorEqLocusEquiv`, `Module.Flat.baseChange`) if you
author one. Keep `\uses{}` accurate to what each Lean proof actually needs. Under 1 chapter edit.
