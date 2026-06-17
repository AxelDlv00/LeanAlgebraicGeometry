# Strategy Critic Directive

## Slug
iter105

## Project goal

The project formalizes, in Lean 4 + Mathlib, the existence and key properties of the Jacobian variety of a smooth proper geometrically irreducible curve `C` over a field `k`, following Christian Merten's challenge (`references/challenge.lean`). The nine declarations in `archon-protected.yaml` are the deliverables: `genus C : ℕ`, `Jacobian C : Over (Spec (.of k))` (with `GrpObj`, `IsProper`, `GeometricallyIrreducible`, `SmoothOfRelativeDimension (genus C)` instances), and the Abel–Jacobi map `ofCurve P : C ⟶ Jacobian C` (with composition and existence-uniqueness lemmas). The Lean skeleton in `AlgebraicJacobian/` is a decomposition of `references/challenge.lean`; signatures there are authoritative.

## Strategy under review

<paste of current STRATEGY.md>

```
# Strategy

## How to read this file

Forward-looking only. The mathematician should be able to see, at a glance, **what
remains** between today and the end-state and **in what order** the remaining work
must happen. History lives in `task_done.md`; per-iteration recipes live in
`PROGRESS.md`. This file is the arc.

## Estimations (auto-maintained)

| Phase | Iterations remaining | LOC remaining | Status |
|---|---:|---:|---|
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~3–6 | ~80 | Iter-105 added two wrapper helpers (`cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear`) and committed a 22-LOC partial proof at L1119–L1147 isolating the residual at L1147 to one morphism-level eqToHom-vs-Pi.π identification at coord `j'`. Iter-106 added a Route 1 lemma (`cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`) signature with sorry body; 4 attempts on L1179 (was L1147) all failed (whnf timeout, discrim-tree). File compiles; 7 sorries (iter-106 added the new lemma sorry). Iter-107 plan picks among: (1) heartbeat lift + retry, (2) lemma rework without eqToHom, (3) bypass wrapper entirely. |
| B — Cotangent sheaves (`Differentials.lean`) | ~8–12 | ~250 | 5 sorries; `h_exact` deferred parallel to `instIsMonoidal_W`. Both Mathlib routes (stalkwise + section-wise) absent. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Not gating other phases. |
| C1 — Refined `LineBundle` | ~3 | ~100 | Body redefinition `CommRing.Pic Γ(X, ⊤)` → invertible-object of `X.Modules`. Refactor scheduled after Phase A/B. |
| C2 — `PicardFunctor` re-derivation | ~2 | ~50 | After C1. |
| C3 — Representability / `JacobianWitness` | ~10–15 | ~1500 | After C2. FGA-via-Hilbert or `Sym^g C / S_g`. Both require Mathlib infrastructure not present. |
| D — `genus`/`Jacobian`/instances | 0 | 0 | Closed iter-073. |
| E — Abel–Jacobi | 0 | 0 | Closed iter-073. |

**Aggregate**: ~27–38 prover iterations and ~1970 LOC remain. Phases A and B are the
near-term bottleneck. Phase C1 contains a critical excuse-comment (LineBundle definition
admitted-wrong by its own docstring per lean-auditor-iter104) that, while contained
(not closed downstream), should be the priority refactor after A.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **no `sorry`** and **no
new `axiom`**, and the nine declarations in `archon-protected.yaml` carry their intended
mathematical content.

## Phase A active target

Close the trailing `sorry` at L1179 of `cechCofaceMap_pi_smul` in
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`. The Lean-side proof
state is: a per-summand R-linearity hypothesis `hG` for an alternating-
sum-of-Pi.lift restriction maps must be discharged at each summand index
`i : Fin (n + 1)`. The iter-099 split-slot lemma
`alternating_sum_pi_smul_aux_sum_comp` is applied to reduce the original
problem to this per-summand discharge. The persistent blocker for 6+
iterations: the inner `Pi.lift fun j ↦ ...` codomain is an anonymous
closure that defeats discrimination-tree pattern unification for
tactic-level scalar pullback (`Preadditive.zsmul_comp`, `ModuleCat.hom_zsmul`,
etc.). Iter-104 + iter-105 broke the per-summand R-linearity into a
named family wrapper engine; the residual at iter-106 is a
morphism-level identification between the named family composed with
an `eqToHom` index-type transport and the wrapper, modulo `Fin.cast`
roundtrip. Three tactical options for iter-107: (1) raise heartbeats,
(2) rework lemma to avoid eqToHom, (3) discard wrapper and prove
per-summand R-linearity directly.

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked. `h_exact` deferred. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 | Defer indefinitely; downstream not gated. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext` (built iter-003–008). |
| `IsLocalizedModule.Away f.1` on finite products | A | Needed for `h_loc_exact`; tractable iter-088+. |
| Hilbert / Quot schemes (or quotients by finite group actions) | C3 | Long leg; one of two routes chosen during C2. |

## Path from today to the end-state

### Near-term (iter-107 → iter-109)

**Iter-107**: address lean-auditor-iter104 cleanup (4 stale "body sorry" docstrings in BasicOpenCech + dead-end `have hPrev` at L728 in iter-106 Route 1 lemma + iter-107 excuse-comment block at L1170 + Differentials 240-line dead block at L675-L912) AND attempt L1179 closure via heartbeat lift (option 1) or lemma rework (option 2).

**Iter-108+** — if iter-107 closes L1179:
- `g_R.map_smul'` (L1813) — needs `Eq.mpr` cast handling.
- `h_loc_exact` (L1842) — needs `IsLocalizedModule.Away f.1` on finite products (~80 LOC).
- Dispatch blueprint-writer for `Cohomology_MayerVietoris.tex` (cechCofaceMap engine prose).

**Iter-108+** — if iter-107 stalls: deeper refactor / route pivot on `cechCofaceMap_pi_smul`'s body, possibly bypassing the wrapper helpers.

### Mid-term — Phase C1 (LineBundle refactor)

**CRITICAL upstream finding**: lean-auditor-iter104 flagged `def LineBundle X := CommRing.Pic Γ(X, ⊤)` in `Picard/LineBundle.lean` as **mathematically wrong** on non-affine schemes (a strict subgroup of true Pic). Currently contained (no theorem proved against it; `representable` refuses closure on top of it). Phase C1 rewrites this to `Invertible` of `X.Modules`.

### Long leg (iter-100+) — Phase C3

Construct $\Pic_{C/k}$ as a scheme. Two routes; choice made during C2:
- (a) FGA-via-Hilbert: requires `Hilb_{C/k}` scheme construction (absent from Mathlib).
- (b) `Sym^g C := C^g / S_g` + Abel–Jacobi birational map: requires finite-group quotients of schemes (absent).

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with
a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _`
applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the
project's choice is between: (a) Leave the inline `sorry` in place at the use site
(preferred — surfaces honest status); (b) Define an iff-form helper as a `theorem ...
:= sorry` if the statement is mathematically TRUE.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the
claim or with one whose signature is mathematically wrong.
```

## References index

```
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex`: Abel–Jacobi map `ofCurve P`, composition + uniqueness lemmas. Status: complete + correct (per blueprint-reviewer-iter104).
- `Cohomology_MayerVietoris.tex`: Mayer–Vietoris core (basic-open cover, Čech acyclicity for `toModuleKSheaf`). Status: partial — missing prose for the active `cechCofaceMap_*_family` engine being formalized in iter-099–106. Soon-fix in iter-107+ post L1179 closure.
- `Cohomology_SheafCompose.tex`: SheafCompose API. Status: complete + correct.
- `Cohomology_StructureSheafAb.tex`: `Scheme.HasSheafify`, `HasExt`, `toAbSheaf`. Status: complete + correct.
- `Cohomology_StructureSheafModuleK.tex`: `HModule`, `HModule'`, comparison API. Status: partial — broken cross-reference `def:Scheme_HModule'` should be `def:Scheme_HModule_prime`.
- `Differentials.tex`: cotangent sheaves; relative differentials; cotangent exact sequence. Status: partial — `\thm:cotangent_exact_sequence` proof sketch is vague; `case h_exact` deferred.
- `Genus.tex`: `genus C : ℕ` and reformulations. Status: complete + correct.
- `Jacobian.tex`: `Jacobian C`, instances, witness route. Status: complete + correct.
- `Modules_Monoidal.tex`: `MonoidalCategory X.Modules`, `LocalizedMonoidal` route, deferred `instIsMonoidal_W`. Status: partial — `instIsMonoidal_W` not named in chapter prose.
- `Picard_Functor.tex`: `PicardFunctor C`, etale-sheafification, representability deferred to C3 (two routes). Status: partial — `representable` intentionally sorry.
- `Picard_FunctorAb.tex`: abelian-group version of PicardFunctor; quot, fiber, etale. Status: complete + correct.
- `Picard_LineBundle.tex`: `LineBundle X := CommRing.Pic Γ(X, ⊤)` global-section approximation — admitted-wrong on non-affine schemes; refactor scheduled C1.
- `Rigidity.tex`: rigidity hypotheses for abelian varieties. Status: complete + correct.

## Prior critique status

This is the first dispatch of strategy-critic since the iter-099/100/101/103 streak escalation events. STRATEGY.md was substantively rewritten across iter-102/Archon (named family refactor), iter-103 (Route B wrapper plan), iter-104 (wrapper helper closures), iter-105 (partial proof at L1147), and now iter-107 (this dispatch). The strategic question for this iter is whether 6 consecutive substantive lanes on the `cechCofaceMap_pi_smul` slot indicate a genuine, narrow, structural blocker that requires one more careful tactic round (the planner's read), or a deeper strategic problem (route mis-design — wrong wrapper, wrong Pi.lift decomposition) that should be challenged.

The lean-auditor-iter104 critical finding on `Picard/LineBundle.lean` (def admitted-wrong) is also a candidate for strategic re-evaluation: Phase C1 currently sits AFTER Phase A, but if the upstream wrongness contaminates downstream effort, it may be cheaper to reorder.
