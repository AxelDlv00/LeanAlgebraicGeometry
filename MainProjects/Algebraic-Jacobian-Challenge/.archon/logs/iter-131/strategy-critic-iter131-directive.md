# Strategy Critic Directive

## Slug
iter131

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only on them. Importantly, `nonempty_jacobianWitness` (the residual claim load-bearing for the protected `Jacobian`-arc declarations) quantifies over an arbitrary smooth proper geometrically irreducible curve `C : Over (Spec (.of k))` of relative dimension 1 — no genus parameter, no $k$-rational-point hypothesis. The end-state is zero inline `sorry` in the project, no named axioms.

## Strategy under review

(Paste verbatim from `.archon/STRATEGY.md`. Plan agent: the strategy is too long for inline pasting; the critic should `Read` the file at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` directly — the whole file is in scope.)

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

(One entry only. The references directory also contains `summary.md` itself.)

## Blueprint summary

Blueprint chapters live at `blueprint/src/chapters/*.tex`. Index (filename + one-line topic):

- `AbelJacobi.tex` — Abel–Jacobi morphism `ofCurve` from the curve `C` to `Jacobian C`; uniqueness statement of factorisation.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris long-exact sequence for `Scheme.HModule`; CLOSED (background infrastructure).
- `Cohomology_SheafCompose.tex` — Sheafification compatibility instance for `forget`-composed sheaves; CLOSED.
- `Cohomology_StructureSheafAb.tex` — `Scheme.toAbSheaf` + `HasExt` instances; CLOSED.
- `Cohomology_StructureSheafModuleK.tex` — `Scheme.toModuleKSheaf` + `HModule` definitions + finite-rank infrastructure; CLOSED.
- `Differentials.tex` — `relativeDifferentialsPresheaf`, `smooth_locally_free_omega`, `kaehler_quotient_localization_iso` (M1.d standalone Mathlib-PR candidate). M1 bridge **EXCISED iter-126**.
- `Genus.tex` — `genus C := finrank k H¹(C, O_C)`; CLOSED.
- `Jacobian.tex` — `JacobianWitness` structure, `nonempty_jacobianWitness` existence, `genusZeroWitness` builder, `Jacobian C` projection and protected instance cluster.
- `Rigidity.tex` — `Scheme.Over.ext_of_eqOnOpen` (functorial rigidity); CLOSED.
- `RigidityKbar.tex` — Active critical-path chapter. Contains M2.a `rigidity_over_kbar` scaffold + shared cotangent-vanishing pile sub-decomposition: piece (i.a) `cotangentSpaceAtIdentity`, piece (i.a-bridge) to local-ring cotangent (`\notready`), piece (i.a) rank lemma (`\notready`), piece (i.b) shear-iso globalisation (`\notready`), piece (i.c) freeness + rank conclusion (`\notready`). Pieces (ii) `Scheme.Over.ext_of_diff_zero` and (iii) absolute Frobenius are referenced but not yet in this file.

## Prior critique status

You have been dispatched in iter-127, iter-128, iter-129, and iter-130. The iter-130 challenges (CHALLENGE, 5 must-fix + 3 alternatives + 2 SOUND) were all addressed via STRATEGY.md edits in iter-130 — see the strategy's "Over-k re-defense on revised numbers" (ground (i) STRUCK iter-130), the Q2 deferred-bridge trigger strengthening, and the Sequencing table Q5 under-count revision (M2.b row 1 iter / 100–200 LOC → 2–4 iter / 320–750 LOC).

Iter-131 question to re-verify (the one substantive piece of news since iter-130's critique): **the iter-130 prover lane that closed `cotangentSpaceAtIdentity` body to Replacement (B) landed kernel-clean and passed the iter-130 progress-critic acceptance test on its literal terms, BUT review-phase audits flagged a structural opacity defect** (the body wraps an explicit chart-base-changed Kähler module witness in `Classical.choice (α := ModuleCat k) ⟨…⟩`, so the result is opaque past `Nonempty`; the rank lemma `cotangentSpaceAtIdentity_finrank_eq` cannot close against this body without first refactoring the body to expose chart data via `Classical.choose`). The iter-131 plan-agent intends to dispatch a refactor lane (not a prover lane) to fix the body shape; no prover dispatch this iter.

Specific questions for you:

1. Does the iter-131 plan (refactor only, defer prover to iter-132) constitute sound execution of the strategy, or does it expose a deeper structural problem with Replacement (B) that should re-open the (B)-vs-(A)-vs-(C) decision from iter-129?
2. The Replacement (B) approach depends on `Classical.choice` for chart selection. The iter-130 body's opacity is a *consequence* of (B)'s non-canonicality. Should the strategy now anticipate that piece (i.b) `mulRight_globalises_cotangent` will need the cotangent at identity as a named-fibre object (which (B)'s chart-dependent form may not provide cleanly)? If so, trigger (a') in STRATEGY.md may need to fire earlier than iter-131+ piece (i.b).
3. Does the iter-129+ "rank lemma" piece (i.a) trio decomposition (definition + bridge + rank) still hold under (B), given that the bridge is now estimated 300–600 LOC and the rank lemma is 50–100 LOC under (B)? The trio framing assumed an iter-128 "no bridge cost" body.
4. Honest sequencing check: STRATEGY.md § Sequencing puts piece (i.b) at iter-131+ (2–4 iter / 200–500 LOC). Given the iter-130 outcome (body lands but body needs follow-up refactor before downstream work), is the piece (i.b) iter-range now iter-132+? If yes, the M2.a body closure iter-150+ chain shifts by 1 iter.
5. Any other strategic claim in STRATEGY.md you challenge.

Be the corrective for sunk-cost reasoning. The plan agent has been building toward Replacement (B) for 2 iters now and is naturally invested in the body that just landed. You are the fresh-mathematician check on whether (B) is still the right route.
