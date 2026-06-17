# Blueprint-writer directive — GF chapter, iter-015

**Chapter to edit (ONLY this file):** `blueprint/src/chapters/Picard_FlatteningStratification.tex`

## Why this round

The iter-014 prover closed `lem:gf_torsion_reindex`
(`AlgebraicGeometry.GenericFreeness.gf_torsion_reindex`) axiom-clean, but the chapter's 4-line
"Transitivity" step (proof at lines ~991–994) under-specified the real content: it produced ~200
lines of Lean and **5 new general-purpose helper declarations** that currently have NO blueprint
entry (they are unmatched `lean_aux` nodes — coverage debt). Your job is to (1) expand the reindex
proof so the localisation-transport content is faithfully described, and (2) add blueprint blocks for
the 5 helpers so the 1-to-1 Lean↔blueprint correspondence is restored. These are **Archon-original
project helpers** (module-theory transport lemmas), NOT theorems from an external source — so they
stand on their proof sketch alone; do NOT fabricate a `% SOURCE`/`% SOURCE QUOTE` citation for them.

## Task 1 — Expand the proof of `lem:gf_torsion_reindex` (label `lem:gf_torsion_reindex`, ~line 915)

The current "Transitivity" paragraph hides the genuinely hard transport. Replace/augment it with an
explicit **"Localisation transport"** sub-step that records what the formalization actually required
(faithful to the Lean proof; this is mathematical prose, no Lean tactic strings):

- The elimination step (`lem:gf_mvPolynomial_quotient_finite_monic`) lands module-finiteness of the
  quotient `Pg/(eF)` over the coefficient subring, where `Pg := MvPolynomial (Fin d) A` localised at
  `MC` (the relevant multiplicative set). Call the resulting localised module `T_g' :=
  LocalizedModule MC T`. The GOAL, however, is stated with `T_g := LocalizedModule (powers g) T`
  (localisation at the powers of the single element `g ∈ A`). These are **two different
  localisations of `T`** that must be identified.
- The base change-of-variables automorphism is realised as a **ring isomorphism** `ebar : Pg ≃+* Pg`
  built via `IsLocalization.ringEquivOfRingEquiv` (NOT `algEquivOfAlgEquiv`: the algebra-equiv version
  requires an `Algebra A (MvPolynomial … A_g)` instance that does not synthesize on the doubly-indexed
  ring; the ring-equiv version needs only `Algebra P Pg` + `IsLocalization MC Pg`, both present). It
  satisfies `ebar(F_g) = G` (the Nagata-normalised generator) and fixes `P`-constants, giving a ring
  iso `ψ : Pg/(F_g) ≃+* Pg/(G)` of the quotient rings (via `Ideal.quotientEquiv` with the span
  equality from `Ideal.map_span`).
- `Module.Finite` is transported across `ψ.symm ∘ ρ` (a ring iso of the *acting* ring, compatible with
  the fixed `R := MvPolynomial (Fin m') A_g`-algebra structure) to yield `Module.Finite R T_g'`.
- The two localisations are identified by an `IsLocalizedModule (powers g)` **descent instance** for
  the restricted scalar map, so that `IsLocalizedModule.linearEquiv` produces `T_g ≃ₗ T_g'`.
- **Record the action-diamond subtlety** (this is the wall the prover hit, worth one or two
  sentences): the existential `IsScalarTower A_g (MvPolynomial … A_g) T_g` in the goal resolves its
  `SMul A_g T_g` to the *canonical* `OreLocalization` action on `T_g = LocalizedModule (powers g) T`,
  overriding the anonymous `Module A_g T_g` witness supplied by the existential binder (a global
  instance beats the binder). Hence the transported action's `A_g`-constants must be shown to agree
  with the canonical localisation action — i.e. the `IsLocalizedModule.linearEquiv` must be upgraded
  to `A_g`-linear (`LinearEquiv.extendScalarsOfIsLocalization`), which is what the `IsScalarTower A A_g
  T_g'` compatibility (`θ(C(algebraMap A A_g a)) = mk(C a)`) establishes.

Keep the existing `% SOURCE QUOTE PROOF` (Nitsure L1766–L1768) intact — it backs the *mathematical*
support-dimension-drop claim. The localisation-transport prose is the project's formalization-faithful
restatement of "localising at the powers of `g`, `T_g` is finite over `A_g[X_1,…,X_{m'}]`"; it is not
a separate source claim.

## Task 2 — Add blueprint blocks for the 5 new helper declarations

All five live in namespace `AlgebraicGeometry.GenericFreeness` in `FlatteningStratification.lean`,
are axiom-clean, and are all consumed (directly or transitively) by `gf_torsion_reindex`. Place them
in a new `\subsubsection{Module-structure transport helpers (reindex)}` near the reindex lemma (after
`lem:gf_torsion_reindex`'s proof, before `lem:gf_polynomial_core`, OR in the
`sec:gf_finite_helpers` area — your call, keep it adjacent to the reindex content). Each block:
a one-line `\begin{lemma}…\end{lemma}` statement (project notation), `\label`, `\lean{}` pin, and a
one-to-three-line `\begin{proof}` with the `\uses{}` of the Mathlib lemmas it leans on. You MAY fold
the three additive-transport helpers (`pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`,
`pullback_isScalarTower`) under a single lemma block with three `\lean{}` pins if that reads better.

The five (with the Lean facts each uses — put Mathlib names in prose, not `\uses` labels, since they
are Mathlib not project decls; reserve `\uses{}` for project labels such as
`lem:gf_torsion_reindex` if you cross-link):

1. `AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv` — `@[reducible] def`. Given an additive
   equivalence `e : M ≃+ N` and an `R`-module structure on `M`, pulls it back to `N` by
   `r • y := e (r • e.symm y)`. No Mathlib deps.
2. `AlgebraicGeometry.GenericFreeness.finite_of_pullbackModuleAddEquiv` — `Module.Finite` transports
   across `pullbackModuleAddEquiv`. Uses `Module.Finite.equiv`.
3. `AlgebraicGeometry.GenericFreeness.pullback_isScalarTower` — `IsScalarTower` transports across the
   pulled-back structures. Uses `smul_assoc`.
4. `AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv` — transports `Module.Finite` across
   a ring isomorphism of the *acting* ring that is compatible with given `R`-algebra structures. Uses
   `AlgEquiv.ofRingEquiv`, `Module.Finite.equiv`, `Module.Finite.trans`.
5. `AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars` — descent of an
   `IsLocalizedModule` along a scalar tower (image-submonoid → base submonoid): given the localisation
   map at the larger monoid, its restriction of scalars is a localisation at the base monoid. Uses
   `isLocalizedModule_iff` / `IsLocalizedModule.mk`, `Module.End.isUnit_iff`,
   `IsScalarTower.algebraMap_smul`.

Wire each helper's `\uses{}` (and the reindex proof's `\uses{}`) so the dependency edges are honest:
`gf_torsion_reindex`'s proof now genuinely depends on helpers 1–5 — add their labels to the proof's
`\uses{}` set.

## Task 3 — Refresh stale prose

If any prose in `lem:gf_polynomial_core` (L5) or its surrounding comments still describes
`gf_torsion_reindex` as "blocked / still sorry", update it to "closed (iter-014)". (The stale inline
comment at `FlatteningStratification.lean:1322–1323` is in the `.lean` file — out of your scope; only
fix stale *blueprint* prose.)

## Out of scope / constraints

- Do NOT edit any other chapter, any `.lean` file, or add/remove `\leanok` (the deterministic
  `sync_leanok` phase owns `\leanok` — never add it, never instruct anything to).
- Do NOT touch the load-bearing statements of `lem:gf_torsion_reindex` / `lem:gf_polynomial_core` —
  only expand their PROOF prose and add the helper blocks.
- The L5 (`lem:gf_polynomial_core`) 5-step proof sketch (lines ~1063–1099) is already adequate — leave
  it unless Task 3 requires a stale-prose fix.
