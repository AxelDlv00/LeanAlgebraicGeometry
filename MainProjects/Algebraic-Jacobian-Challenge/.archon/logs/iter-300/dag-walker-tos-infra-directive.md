# DAG Walker Directive

## Slug
tos-infra

## Seed
lem:pullback_tensor_map_basechange

## Mission (READ THIS FIRST — overrides default "walk the whole cone")
The USER has explicitly flagged that the project DAG has **54 isolated `lean_aux`
nodes** (Lean declarations in `Picard/TensorObjSubstrate*` with NO blueprint
entry) and wants them connected into the goal cone. This directive assigns you a
**specific bounded sublist of 20 of them**, all in
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`. Your job: give each one a
blueprint block in `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(`\begin{definition}`/`\begin{lemma}` with `\label`, `\lean{<full name>}`,
accurate `\uses{}`, and a proof note), AND wire it into the cone so it is no
longer isolated — see "De-isolation" below. Do NOT range outside this sublist;
the other 34 isolated decls are handled by sibling walkers writing the SAME file,
so touch ONLY your 20 blocks plus the `\uses{}` of their direct consumers.

## The 20 assigned Lean declarations (all in `Picard/TensorObjSubstrate.lean`)
All are **sorry-free in Lean** (effort 0) — none is ∞. Each block's proof
environment is therefore a one-line note: `\begin{proof} Proved directly in
Lean; <one phrase recalling the mechanism>. \end{proof}`. These are PROJECT
declarations (not Mathlib re-exports), so do NOT mark them `\mathlibok`.

Change-of-rings adjunction infrastructure:
- `AlgebraicGeometry.Scheme.Modules.extendScalars` — left adjoint of `restrictScalars φ` (def).
- `AlgebraicGeometry.Scheme.Modules.extendScalarsAdjunction` — `extendScalars φ ⊣ restrictScalars φ`.
- `AlgebraicGeometry.Scheme.Modules.pullback0` — left adjoint of `pushforward₀ F R` (def).
- `AlgebraicGeometry.Scheme.Modules.pullback0Adjunction` — `pullback0 F R ⊣ pushforward₀ F R`.
- `AlgebraicGeometry.Scheme.Modules.pushforward₀IsRightAdjoint` — `pushforward₀ F R` is a right adjoint.
- `AlgebraicGeometry.Scheme.Modules.restrictScalarsIsRightAdjoint` — `restrictScalars φ` is a right adjoint (it is `pushforward (F:=𝟭) φ`).
- `AlgebraicGeometry.Scheme.Modules.restrictScalarsId_map` — `(restrictScalars (𝟙 R)).map g = g` (identity-of-rings acts trivially on morphisms).

Change-of-rings monoidal (μ / ε) coherence:
- `AlgebraicGeometry.Scheme.Modules.restrictScalars_μ_app` — value at an open `W` of the lax monoidal structure map `μ` of `restrictScalars α`.
- `AlgebraicGeometry.Scheme.Modules.restrictScalars_μ_app_tmul` — same, evaluated on a pure tensor `m ⊗ n`.
- `AlgebraicGeometry.Scheme.Modules.forget₂_restrictScalars_μ_hom_tmul` — `forget₂`-image of `ModuleCat.restrictScalars`'s `μ` on a pure tensor.
- `AlgebraicGeometry.Scheme.Modules.pushforward_map_restrictScalars_μ_app_tmul` — `pushforward`-image of the `restrictScalars` `μ` on a pure tensor.
- `AlgebraicGeometry.Scheme.Modules.pushforward_μ_eq` — `μ(pushforward φ) = μ(restrictScalars φ')` on `pushforward₀`-objects (the two lax structures agree).
- `AlgebraicGeometry.Scheme.Modules.pushforwardComp_lax_μ` — `pushforwardComp` is monoidal: its comparison commutes with the lax `μ`'s (change-of-rings `extendScalars`/`restrictScalarsComp` coherence).
- `AlgebraicGeometry.Scheme.Modules.pullbackComp_δ` — the oplax `δ` analogue: the `pullbackComp` comparison commutes with the oplax `δ`'s (mate of `pushforwardComp_lax_μ`).

Bridges / housekeeping helpers:
- `AlgebraicGeometry.Scheme.Modules.forget_map_pushforward_map` — `(forget).map (pushforward φ .map …)` reconciliation bridge (`rfl`-level binding obligation).
- `AlgebraicGeometry.Scheme.Modules.toRingCatSheafHom_comp_hom_reconcile` — the ring-map reconciliation `toRingCatSheafHom (h≫f) = …` used in the Sq2 ring reconcile (definitional).
- `AlgebraicGeometry.Scheme.Modules.W_of_isIso_sheafification` — if the sheafification of a presheaf-of-modules map is an iso then the map is `W` (locally bijective) (general sheafification fact, project-stated).
- `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` — `toPresheaf`-image of a `homMk` is computed by the underlying map.
- `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` — restricting a unit-trivialisation `M.restrict U ≅ 𝟙_U` along `W ≤ U` gives `M.restrict W ≅ 𝟙_W`.
- `AlgebraicGeometry.Scheme.Modules.tensorObj_middleFour` — the middle-four interchange iso reorganising `(A⊗B)⊗(C⊗D)` used inside the `tensorObj` associativity/commutativity coherence.

## De-isolation (the point of this dispatch)
A new block that only *exists* is still isolated. For EACH of your 20, give it at
least one graph edge so it lands in the goal cone:
- Write its own `\uses{}` to the existing blueprint labels of the facts its Lean
  proof actually invokes (read the `.lean` proof — it is the ground truth).
- Then add the new label to the `\uses{}` of its existing **consumer** block so
  there is an incoming edge from the cone. Read the Lean to find the consumer.
  Likely consumers already present in the chapter (do not invent labels — verify
  each exists with `grep '\label{' Picard_TensorObjSubstrate.tex`):
  - `lem:pullback_tensor_map_basechange` (seed) consumes `pullbackComp_δ`,
    `pushforward_μ_eq`, `pushforwardComp_lax_μ`, the `restrictScalars_μ_*` family,
    `forget₂_restrictScalars_μ_hom_tmul`, `pushforward_map_restrictScalars_μ_app_tmul`.
  - `lem:restrictscalars_laxmonoidal`, `lem:restrictscalars_ringiso_tensorequiv`,
    `def:restrict_scalars_lax_mu`, `lem:restrictscalars_ringiso_tensorequiv_apply_tmul`
    are the natural neighbours of the `restrictScalars_μ_*` blocks.
  - `lem:presheaf_pushforward_adj_substrate`, `lem:presheaf_pullback_oplaxmonoidal`,
    `lem:presheaf_pushforward_laxmonoidal` are neighbours of the
    `extendScalars`/`pullback0`/`pushforward₀`/`restrictScalars` adjunction defs.
  - `def:scheme_modules_tensorobj` / `lem:tensorobj_assoc_iso` consume `tensorObj_middleFour`.

If a genuine consumer is a *protected* block (none here — the protected decls are
in Genus/Jacobian/AbelJacobi, not this chapter), you would only report it; but
this chapter is unprotected, so wire freely.

## Verification before you finish
Run `archon dag-query node --node <each new label> --json` (or re-`leandag build`
+ `leandag show isolated`) and confirm each of your 20 new labels has ≥1 edge and
none of your 20 Lean names still appears in `leandag show isolated`. Re-query and
fix until your 20 are all wired.

## Scope boundary
- ONLY add blocks for the 20 listed decls and edit the `\uses{}` of their direct
  consumers. Do NOT rewrite existing statement/proof prose. Do NOT touch the
  34 decls owned by sibling walkers (the `sheafify*`/`pullback*Iso`/`pic*`/`tensorObj*Iso`
  cluster and the `dual*` cluster).
- Mathematical prose only — no Lean tactic syntax in bodies. The only Lean token
  is the `\lean{}` annotation.
- NEVER add `\leanok` (deterministic sync owns it). Do NOT `\mathlibok` these
  project decls.

## References
These are project-internal category-theory infrastructure built on Mathlib's
`PresheafOfModules` / `restrictScalars` / `pushforward` / sheafification API; no
external textbook source. Use `\textit{Source: project-internal infrastructure
over Mathlib's \texttt{PresheafOfModules} change-of-rings API; proved directly in
Lean.}` as the provenance line. No `% SOURCE QUOTE` is required since nothing is
transcribed from an external reference. Do NOT fabricate a citation.
