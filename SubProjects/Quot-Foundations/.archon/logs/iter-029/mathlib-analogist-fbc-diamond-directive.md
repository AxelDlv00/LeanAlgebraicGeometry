# mathlib-analogist directive — FBC eCancel instance-diamond (cross-domain)

## Mode: cross-domain-inspiration

## Structural problem

In `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` the proof of
`base_change_mate_fstar_reindex_legs` (and, identically, `base_change_mate_gstar_transpose`) must
**rewrite ONE factor inside a long composite of `Functor.map` images** of the form

    Γ.map ( … ≫ (pushforwardComp g' (Spec φ)).hom.app X ≫ … )

where the factor to collapse is `Γ.map ((pushforwardComp g' (Spec φ)).hom.app _)`, provably equal to
`𝟙 _` by the in-file lemma `gammaMap_pushforwardComp_hom_eq_id` (cheaply elaborable as a term `hpfc`).

The obstruction is an **instance diamond in the `X.Modules` category** (`CategoryStruct.comp` /
`Functor.map`): after a `rw [Functor.map_comp]` split, the goal's matching factor lives over the
NESTED-`obj` form of the composite functor `pushforward g' ⋙ pushforward (Spec φ)`, whereas the
collapse lemma's term lives over the COMPOSED-`⋙` form. The two are **defeq but not syntactically
equal**, so the motive cannot be abstracted by keyed rewriting, and a defeq-tolerant rewrite times out
on the huge concrete leg term. The same diamond recurs at each of the three atom cancellations
(`_eCancel_eUnit` / `_pushforwardComp` / `_pullbackComp`) against the unfolded
`base_change_mate_codomain_read_legs`.

I need the **canonical term-mode mechanism** to rewrite a single factor inside a `Γ ∘ (Spec φ)_*`
functor-image composite when that factor's `Functor.map` implicit domain is in the wrong (obj-nested
vs ⋙-composed) syntactic form — without any head-symbol `rw`/`simp`/`erw`. Concretely: which Mathlib
idiom (`congrArg`, `Functor.map_comp` as a term, `CategoryTheory.eqToHom`/`eqToIso` transport,
`Functor.Comp`/`associator` coherence, `whiskerLeft`/`whiskerRight`, `Iso.inv_comp_eq`, defeq-inside-
`exact`) is the standard way to do single-factor surgery inside a long functor-image composite, and how
to carry it through the whole composite term-by-term.

## Key lead — the GR lane in THIS project already solved the SAME diamond class

In `AlgebraicJacobian/Picard/GrassmannianCells.lean`, `chartTransition'_fac` faced the identical
instance-diamond class (a `HasPullback`/Scheme-category diamond: the same literal `awayPullbackIso`/
`pullback.snd` elaborates to different instance terms in the def body vs a freshly-typed term vs the
statement; `rw`/`simp` of `Category.assoc`/`Iso.inv_hom_id`/`awayPullbackIso_inv_snd` all silently
no-op). The lane found a WORKING recipe (axiom-clean, landed iter-028):
- keep the iso from ONE source so `.hom`/`.inv` share the instance — e.g.
  `hfst := (Iso.inv_comp_eq _).mp (awayPullbackIso_inv_fst _ _)`;
- `erw [awayPullbackIso_inv_snd]` (defeq-tolerant) fires the leg through the diamond;
- `exact congrArg (_ ≫ ·) hXY` closes the final equation — **associativity and the diamond are handled
  by defeq INSIDE `exact`**, which is NOT available to `rw`/`simp`.

Read both proofs (`chartTransition'_fac` and its `_ringIdentity` helper in GrassmannianCells.lean, and
the sorry block + comments of `base_change_mate_fstar_reindex_legs` ~lines 1392–1450 in
FlatBaseChange.lean). Tell me **whether and exactly how the GR `exact congrArg`/defeq-inside-`exact`
recipe ports to the FBC functor-image setting** (GR is over the Scheme category with `HasPullback`
instances; FBC is over `X.Modules` with `Functor.map`/composed-functor `obj`), and what the canonical
Mathlib term-mode pattern is for the functor-image case. If Mathlib has solved the same "rewrite a
factor inside a long functor-map composite past an instance/coherence diamond" shape in any domain
(simplicial/cosimplicial, monoidal coherence, sheafification naturality, adjunction mate calculus),
bring those citations + the technique each used.

## Failed approaches

- `rw [gammaMap_pushforwardComp_hom_eq_id]` / `simp only [...]` — "did not find pattern" / "no progress"
  (keyed match defeated by the obj-nested vs ⋙-composed mismatch).
- `rw [Functor.map_comp]` / `simp only [Functor.map_comp]` — no progress on the four-factor goal.
- `erw [gammaMap_pushforwardComp_hom_eq_id]` — `whnf` heartbeat timeout (1.6M, then 4M) on the huge leg.
- Explicit `have hpfc := gammaMap_pushforwardComp_hom_eq_id _ _ _` (elaborates cheaply) then
  `rw [hpfc]`/`simp only [hpfc]` — still "no occurrence" (same syntactic-form mismatch).

## Search radius: wide

## Deliverable

A concrete, ported term-mode recipe (with Mathlib citations) the FBC prover can apply THIS iter to
collapse the surviving `pushforwardComp` Γ-factor and then the three eCancel atoms — explicitly
addressing whether the GR `exact congrArg`/`erw`/`Iso.inv_comp_eq` recipe transfers, and if not, what
the correct functor-image analogue is. Persist the rationale to `analogies/fbc-functorimage-diamond.md`.
