# Blueprint Reviewer Directive

## Slug

iter115

## Strategy snapshot

The project formalizes the **Jacobian of a smooth proper geometrically irreducible curve over a field** following Christian Merten's challenge (`references/challenge.lean`). The 9 protected declarations in `archon-protected.yaml` are the deliverables: `genus`, `Jacobian` + 4 instances, `Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`.

The strategy ships a Jacobian framework conditional on a small set of named Mathlib gaps and one budget-deferral. Project-level scope splits into:

- **Phase A — Čech acyclicity** (`Cohomology/BasicOpenCech.lean`): 6 sorries, all off-limits. L1120 PAUSED; L1212/L1536/L1564 substep-deferred; L1754 gated on L1120; L1846 budget-deferred.
- **Phase B — Cotangent sheaves** (`Differentials.lean`): 5 sorries. L798 (`h_exact`) named-deferred; L1039 (`serre_duality_genus`) named-deferred (~3000–8000 LOC out of scope). Phase B autonomous-loop scope is 3 sorries: L175 (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type`), L880 (`smooth_iff_locally_free_omega`), L897 (`cotangent_at_section`).
- **Phase C0 (`Modules/Monoidal.lean`)** — `instIsMonoidal_W` Mathlib gap (varying-ring `stalk_tensorObj`); off-limits.
- **Phase C1** — DONE iter-109 (`LineBundle X := (Skeleton X.Modules)ˣ`).
- **Phase C2 (`Picard/Functor.lean`)** — 1 sorry on `representable` gated on C3.
- **Phase C3** — DEFERRED via `JacobianWitness` exit policy (`Jacobian.lean:179`, 1 sorry).
- **Pair gap (`Picard/LineBundle.lean`)** — 2 sorries L82 / L96 (named Mathlib-gap pair `pullback_tensorObj` + `pullback_oneIso`).

This iter (iter-115) plans to **open the L175 prover lane** on `Differentials.lean` with the iter-114 analogist-verified corrected recipe:

- Step 1: Affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde` (no off-the-shelf basis-to-X sheaf bridge in Mathlib b80f227; hand-rolled).
- Step 2: Hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover`.
- Step 3: Uniqueness via `TopCat.Presheaf.Sheaf.eq_of_locally_eq` + `KaehlerDifferential.span_range_derivation`.

The iter-114 plan-phase already dispatched a two-pass blueprint-writer round on `Differentials.tex`:
- First pass (slug `differentials-iter114`): landed the 4 blueprint-reviewer-iter114 must-fix items (added `\lem:relative_kaehler_isSheafUniqueGluing` declaration + Option (i) delegation in `\thm:relative_kaehler_isSheaf` + stale `% NOTE` removals + Serre-duality prose relaxation).
- Second pass (slug `differentials-recipe-fix-iter114`): replaced the proof body of `\lem:relative_kaehler_isSheafUniqueGluing` with the analogist-verified Mathlib-name recipe (affine-basis identification + cofinality descent + uniqueness; explicit `[gap]` callout on the missing basis-to-X bridge).

Your iter-115 mandatory dispatch is the green-light gate for the L175 prover lane. Confirm `Differentials.tex` is now `complete: true × correct: true` with no must-fix-this-iter findings touching it. Also audit every other chapter as usual.

## Routes

Single route. The strategy has one selected route per phase, with several alternatives documented as future options / fallbacks but not active this iter:

- Phase B closure route: **iter-113 unique-gluing reformulation** of the sheaf condition, with the load-bearing residual at `\lem:relative_kaehler_isSheafUniqueGluing`. The analogist-verified Step 1 / Step 2 / Step 3 recipe is the closure plan.
- Phase C3 exit: **JacobianWitness exit policy** with a single existence sorry; no alternative is being pursued this iter.

Alternatives documented in `STRATEGY.md` (not active):
- Narrower L880+L897-only trim (scope-rationale section; "Open option" gated on iter-115+ CHURNING on L880-converse).
- Divisor-class-image Pic⁰ route to C3 (documented future work).

## References

- `references/challenge.lean` — Christian Merten's authoritative spec; protected signatures derive from here.
- `analogies/affine-basis-sheaf-bridge.md` — iter-114 mathlib-analogist persistent file documenting why no off-the-shelf basis-to-X sheaf bridge exists in Mathlib b80f227; the cofinality descent in `\lem:relative_kaehler_isSheafUniqueGluing`'s Step 2 is unavoidable. Read this before auditing `Differentials.tex`.
- `analogies/c1-route.md` — iter-108 c1-route decision rationale for `LineBundle X := (Skeleton X.Modules)ˣ`.
- `analogies/serre-duality.md` — iter-110 serre-duality named-deferral rationale.

## Focus areas

- **`Differentials.tex`** — the high-priority audit target this iter. Confirm the iter-114 two-pass writer round has produced a complete + correct chapter. In particular:
  - Is the new `\lem:relative_kaehler_isSheafUniqueGluing` declaration block present with the corrected Step 1–3 recipe (Mathlib names verifiable: `KaehlerDifferential.isLocalizedModule_map`, `AlgebraicGeometry.Modules.tilde`, `isSheaf_iff_isSheafOpensLeCover`, `TopCat.Presheaf.Sheaf.eq_of_locally_eq`, `span_range_derivation`)?
  - Does `\thm:relative_kaehler_isSheaf`'s proof delegate properly to the new lemma via the framework Mathlib chain?
  - Are the 3 stale `% NOTE (iter-112 review)` blocks gone?
  - Has the `\thm:serre_duality_genus` prose been relaxed to `IsIntegral` + `Smooth` (no "geometrically irreducible"; no dimension-1 assertion)?
  - Are the soon-severity items from iter-114 (stale Lean line-ref on `\def:relative_kaehler_presheaf`, quasi-coherence prose on `\def:relative_kaehler_sheaf`, `\thm:cotangent_exact_sequence` formulation) still soon or have they been opportunistically addressed?
  - Is the explicit `[gap]` callout in `\lem:relative_kaehler_isSheafUniqueGluing` Step 2 honest (no off-the-shelf basis-to-X bridge; the descent is hand-rolled)?

- **All other chapters** — quick re-verification that nothing regressed from iter-114's complete + correct verdict.

## Known issues

The plan agent already knows the following — do NOT re-flag as findings unless the situation has changed:

- `Cohomology_MayerVietoris.tex` carries some iter-112-era line-ref drift; this is soon-severity and does not block any active prover lane this iter (BasicOpenCech.lean is off-limits).
- `Picard_FunctorAb.tex` may have a soon-severity "scaffolded" wording remnant flagged iter-112 then noted as possibly stale in iter-114; if you still see it, flag it but it is non-blocking (FunctorAb.lean has 0 sorries).
- `Differentials.tex` carries an explicit `[gap]` callout in `\lem:relative_kaehler_isSheafUniqueGluing` Step 2 saying "no off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X; the cofinality descent above is hand-rolled this iter, and the iter-115 prover must build it inline (verified by the iter-114 Mathlib analogist)." This `[gap]` is **honest disclosure**, not a soundness issue — do not flag it as a must-fix.

Report verdicts per chapter (complete / correct + notes) plus the three top-level summaries (Incomplete parts, Proofs lacking detail, Lean difficulty quality). Apply the must-fix-this-iter rules verbatim — any chapter with `complete: partial | false` or `correct: partial | false` is must-fix, even if the strategy doesn't require that chapter this iter.
