# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
fbc-mate

## Iteration
020

## Structural problem
Expand the adjunction **unit at a composite morphism** `g' = a ≫ b` via the four-factor
unit-of-composite identity, distribute `(Spec φ)_* ⋙ Γ` over the factors, then telescope the
`pullbackComp`/`pushforwardComp` pseudofunctor coherence isos against a codomain dictionary
(`base_change_mate_fstar_reindex_legs`, Seam 2 / fstar-reindex). The obstruction is structural: the
codomain object `base_change_mate_codomain_read_legs` is parametrized by the **equality proofs**
`hfst : g' = a ≫ b`, `hsnd : f' = …`; after `subst` the leg is a locked literal that no positional
`rw [unitExpand]` can re-abstract (dependent-motive wall), and the `X.Modules` instance diamond
blocks the supporting `assoc`/`map_comp` rewrites.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `…/ModuleCat/Sheaf/PullbackContinuous.lean` (`pullbackComp` 166, `conjugateEquiv_pullbackComp_inv` 176, `pullback_assoc` 192) | alg-geom / sheaves of modules (project's upstream) | low–medium | ANALOGUE_FOUND |
| `CategoryTheory/Adjunction/CompositionIso.lean` (`leftAdjointCompNatTrans_assoc` 155, `…₀₂₃_eq_conjugateEquiv_symm` 140) | generic adjunction calculus | medium | ANALOGUE_FOUND |
| `CategoryTheory/Adjunction/Mates.lean` (`mateEquiv_vcomp` 167, `conjugateEquiv_comp` 337, `unit_conjugateEquiv_symm` 305) | generic mate / Beck–Chevalley | medium | ANALOGUE_FOUND |

## Key diagnosis
The leg-lock is a symptom; the disease is **parametrizing a coherence object by an equality proof**.
Mathlib's pull/push pseudofunctor stack — which the project already imports as `Scheme.Modules.*`
(Sheaf.lean:219/238/257) — *never* does this. Every coherence (`pullbackComp`, `pushforwardComp`,
`pullback_assoc`) is a function of **free morphism variables**, built/telescoped through the
conjugate-mate bijection, with the composite written explicitly (`φ ≫ (sheafPushforward).map ψ`).
That is exactly why Mathlib never hits a leg-lock: there is no proof argument to make the motive
dependent, and the composite is manipulated on the conjugate (right-adjoint) side as a free variable,
not as a positional `rw` target.

## Top suggestion
Two-stage port, both inside `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`.

1. **Decouple from the proofs (PullbackContinuous discipline).** Re-cut
   `base_change_mate_codomain_read_legs` (~line 1210) so it is a function of the *free morphisms*
   only — built from `Scheme.Modules.pullbackComp`/`pushforwardComp`/`pullbackCongr` plus
   `pushforwardCongr comm` for the square (a Prop arg to a functor, **not** an `And.casesOn` on a
   leg-equality proof). Then restate `base_change_mate_fstar_reindex` (~1435) at the **explicit
   composite** `e.hom ≫ Spec.map inclA` (no free `g'`, no `subst hfst/hsnd`). With no proof-carrying
   object, `base_change_mate_fstar_reindex_legs_unitExpand a b N` and `_gammaDistribute` unify on the
   genuine syntactic `(?a ≫ ?b)` — the wall described in the directive vanishes because there is
   nothing to re-abstract. This mirrors `pullback_assoc` (PullbackContinuous.lean:192 / Sheaf.lean:257),
   which states the four-cell pentagon over free `φ ψ ψ'` in one line.

2. **If a residual cancellation still resists positional `rw` (the diamond), use conjugate-lift
   telescoping** (CompositionIso `leftAdjointCompNatTrans_assoc`, lines 155–164, via
   `…₀₂₃_eq_conjugateEquiv_symm` 140–153): replace the locked nat-trans with a fresh free variable by
   `obtain ⟨_, rfl⟩ := (Scheme.Modules.conjugateEquiv …).surjective _`, then
   `apply (Scheme.Modules.conjugateEquiv …).injective` to move the whole identity to the pushforward
   side, where `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (Sheaf.lean:238) turns the
   `pullbackComp` factor into `pushforwardComp.hom` and the project's existing
   `gammaMap_pushforwardComp_*`/`gammaMap_pushforwardCongr_hom` collapse lemmas fire. The telescoping
   then runs entirely through the `@[reassoc (attr := simp)]` conjugate simp set — `conjugateEquiv_comp`
   (Mates.lean:337), `conjugateEquiv_whiskerLeft/Right` (525/536), `conjugateEquiv_associator_hom`
   (501) — never positional `rw` on a locked literal, so the diamond never bites. This is the
   structural answer to directive points (2) telescope via reassoc simp set and (3) survive the
   instance diamond by working conjugate-side and specializing last.

Mate-of-composite without `subst` (directive point 1) is the standing idiom in all three files:
`mateEquiv_vcomp`/`conjugateEquiv_comp` state the composite identity abstractly and specialize with
`congr_app`, and `unit_conjugateEquiv_symm` is the single-step unit transport (already cited for
Seam 1 in `analogies/fbc-mate.md`).

## Persistent file
- `analogies/fbc-mate-legreindex.md` — analogue list + root-cause reframing for future iters.
  (The prior `analogies/fbc-mate.md` covers Seam 1's unit-transport; this new file covers Seam 2's
  composite-leg telescoping and is intentionally separate.)

Overall verdict: the leg-lock is self-inflicted by proof-parametrizing the codomain read — Mathlib's
own `Scheme.Modules` pull/push stack shows the fix is to keep legs free (state at the explicit
composite, build coherences from `pullbackComp`/`pushforwardComp`) and, if needed, telescope on the
conjugate side via `conjugateEquiv.injective`/`surjective` + the reassoc conjugate simp set.
