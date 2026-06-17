# Strategy Critic Directive

## Slug
iter108

## Project goal

The project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge file (`references/challenge.lean`). The deliverables are nine protected declarations:

- `AlgebraicGeometry.genus` (in `AlgebraicJacobian/Genus.lean`)
- `AlgebraicGeometry.Jacobian`, plus four instances on it: `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible` (in `AlgebraicJacobian/Jacobian.lean`)
- `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` (in `AlgebraicJacobian/AbelJacobi.lean`)

The end-state is: all nine signatures compile with intended mathematical content modulo a small set of named Mathlib-gap sorries. Phase C3 (`nonempty_jacobianWitness`) was deferred via the JacobianWitness exit policy iter-107 (Archon canonical) after the strategy-critic-iter105 REJECT on the original C3 estimate.

## Strategy under review

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
| A — Čech acyclicity (`BasicOpenCech.lean`) | ~5–9 | ~130–280 | Iter-109 (narrative) / Archon iter-107 plan: SINGLE SUBSTANTIVE PROVER LANE on L1802 `h_loc_exact` — continued the mathlib-analogist Q1 ALIGN_WITH_MATHLIB recipe, attempted Steps 1c–4 (Steps 1a–1b landed iter-108). Iter-109 outcome: PARTIAL (Step 1c landed inline at L1796–L1834 = 40 LOC; Steps 2–4 hit a structural blocker — `letI ... in <goal-type>` does not propagate to body binders for per-x algebra threading). **L1846 is now at the iter-107 strategy-critic exit-criterion threshold** (second consecutive PARTIAL on the same residual). The iter-110 (narrative) escape-valve menu MUST fire (defer-as-named-Mathlib-gap OR fire C1 promotion OR analogist re-consult). **L1120 active-route status: PAUSED** (progress-critic-iter106/107 STUCK; 7 consecutive PARTIAL). |
| B — Cotangent sheaves (`Differentials.lean`) | ~8–12 | ~250 | 5 sorries; `h_exact` deferred parallel to `instIsMonoidal_W`. **Variance flag** (carried from strategy-critic-iter107): `serre_duality_genus` at L877 is the single Phase B sorry with the highest LOC variance; before scheduling Phase B, dispatch `mathlib-analogist` on Mathlib's Serre-duality coverage for `Module.finrank`-style consumers at the curve level. |
| C0 — Monoidal `X.Modules` | — | 0 | `instIsMonoidal_W` deferred (Mathlib gap `stalk_tensorObj` for varying-ring R₀). Not gating other phases. |
| C1 — Refined `LineBundle` | ~5–8 | ~200–300 | Strategy-critic-iter105 revised: estimate up from 3 iters / ~100 LOC. Mathematically right move regardless of Phase A status. **C1 promotion trigger fired iter-107**, deferred ONE iter pending iter-108 prover outcome on L1802 (the iter-108 was PARTIAL but positive trajectory). Iter-109 (Archon-107) dispatched a further L1802 prover round; iter-109 also PARTIAL → iter-110 plan MUST fire either C1 promotion OR defer-L1802-as-named-Mathlib-gap; no further L1846 prover deferral permitted. Defer-as-gap is structurally cheaper (single named sorry, no scope expansion); C1 promotion is materially the right move regardless of Phase A outcome (the LineBundle approximation is mathematically wrong and the user hint mandates its replacement). |
| C2 — `PicardFunctor` re-derivation | ~4–6 | ~150 | Strategy-critic-iter105 revised: full re-derivation including étale sheafification and abelian-group structure on top of new `LineBundle`. |
| C3 — Representability / `JacobianWitness` | DEFERRED via JacobianWitness exit policy | — | Strategy-critic-iter105 REJECT on original estimate (10–15 iters / ~1500 LOC wildly under-counted). `nonempty_jacobianWitness` sorry at `Jacobian.lean:179` is the single named gap on a precise Mathlib gap (Hilbert/Quot schemes; finite-group quotients of schemes — both confirmed absent from Mathlib b80f227). |
| D, E — `genus`/`Jacobian`/instances + Abel–Jacobi | 0 | 0 | File-level closure; content-level BLOCKED-ON-C3-WITNESS. |

**Aggregate**: ~21–33 prover iterations and ~480–630 LOC remain for what the autonomous loop will deliver (Phases A, B, C1, C2). Phase C3 deferred. The final project terminates with **3–4 named Mathlib-gap sorries** in scope: `instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`, `PicardFunctor.representable`. Plus possibly L1846 in `BasicOpenCech.lean` if the iter-110 (narrative) escape-valve picks **defer-as-gap** over **fire C1 promotion**.

## Phase A escape-valve menu (FIRES this iter; iter-110 narrative / Archon-108)

Iter-109 (narrative) prover delivered second consecutive PARTIAL on L1846. Per the iter-107 strategy-critic exit criterion, the iter-110 (narrative) plan MUST pick exactly one:

- (i) **Defer L1846 as the fourth named Mathlib gap**. Mark with `-- MATHLIB GAP: IsLocalizedModule.Away f.1 on the slice-cover product of restricted basic-opens (Γ(V_x ⊓ D(f.1)) viewed as a Γ(V_x)-localisation; finite-product transport via IsLocalizedModule.pi)`. Surface as a 4th named gap alongside `instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`. Strictly cheaper. Default choice unless the strategy explicitly argues for C1.
- (ii) **Fire C1 promotion**. Refactor `Picard/LineBundle.lean` body from `CommRing.Pic Γ(X, ⊤)` to `MonoidalCategory.Invertible (X.Modules)`. Independent of L1846 status.
- (iii) **Mathlib-analogist re-consult on a different decomposition of L1846**. The Q1 recipe was the analogist's first pass; a second pass might recommend (e.g.) `LocalizedModule.map_exact` after a separate proof of K₀ exactness.

The plan agent is leaning **Option (i)** (cheapest; iter-109 prover report itself recommends).

## Phase C3 exit policy (adopted iter-107)

The strategy-critic-iter105 audit returned REJECT on Phase C3 with the argument that both proposed routes (FGA-via-Hilbert; `Sym^g C / S_g`) require constructing Mathlib infrastructure that is a Hartshorne-chapter-sized undertaking (~5,000–10,000 LOC each), wildly exceeding the project's stated estimate.

**Adopted exit policy**: defer Phase C3 indefinitely via the `JacobianWitness`-witness pattern. The protected `Jacobian C`, `ofCurve P`, and downstream instances carry sorry-routed bodies that reduce to `Nonempty (JacobianWitness C)`. The strategy-critic's "divisor-class-image Pic⁰" alternative (avoiding both Hilbert and Sym^g via scheme-theoretic image of `C^g → Pic^g` + Riemann–Roch effective theory) is documented as a future-work option but not selected — the prerequisite infrastructure is itself missing from Mathlib b80f227.

## End-state

`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **only the named Mathlib-gap sorries listed above** and **no new `axiom`**. The nine declarations in `archon-protected.yaml` carry the intended mathematical content **up to the JacobianWitness gap**, with all other infrastructure (Čech cohomology, cotangent sheaves, sheafified Picard functor) delivered.

**Plain-language disclosure of the End-state**: the protected declarations compile against a `Nonempty (JacobianWitness C)` witness whose existence sorry is at `Jacobian.lean:179`. The project ships a Jacobian *framework*, conditional on the witness — it does NOT autonomously construct the Jacobian. A fresh reader should understand: "did you build the Jacobian of a smooth proper curve?" answers as "no, we built every Jacobian-derived instance + AbelJacobi morphism + downstream consequences AGAINST the named existence hypothesis `nonempty_jacobianWitness`".

## Mathlib gaps in scope

| Gap | Phase | Plan |
|---|---|---|
| Stalkwise criterion for `SheafOfModules` exactness | B | Both routes confirmed Mathlib-gap blocked. `h_exact` deferred parallel to `instIsMonoidal_W`. |
| `(M ⊗_psh N).stalk x ≅ M.stalk x ⊗ N.stalk x` (varying-ring `R₀`) | C0 | Defer indefinitely; downstream not gated. |
| Sheaf cohomology `Hⁱ(X, F)` for quasi-coherent sheaves | A | Project-local `HModule`/`HModule'` via `Abelian.Ext` (built iter-003–008). |
| `IsLocalizedModule.Away f.1` on finite products of restricted basic-opens | A | Iter-110 (narrative) escape-valve menu may upgrade to a 4th named Mathlib-gap if Option (i) wins; if Option (ii) wins, this stays as an in-progress L1846 sorry under continued (post-C1) prover work. |
| Hilbert / Quot schemes | C3-DEFERRED | Phase C3 deferred via JacobianWitness exit policy. |
| Finite-group quotients of schemes | C3-DEFERRED | Same. |
| Riemann–Roch effective theory + scheme-theoretic image (for divisor-class-image alternative) | C3-DEFERRED | Mathlib gap; future-work option. |

## Path from today to the end-state

### Iter-110 narrative / Archon iter-108 (this iter's plan)

Phase A escape-valve menu fires (see above). Plan agent leaning Option (i). After the escape-valve, the iter is light on substantive prover dispatch — likely a single prover round on the chosen escape-valve action (replace L1846 sorry with a clearly-marked `-- MATHLIB GAP` annotation under Option (i); refactor LineBundle.lean under Option (ii); etc.).

### Mid-term — Phase B (~iter-111+ contingent on Phase A resolution)

Address `Differentials.lean` non-`h_exact` sorries (L122, L718, L735, L877). `h_exact` (L636) stays deferred parallel to `instIsMonoidal_W`. **Variance flag**: `serre_duality_genus` at L877 — dispatch `mathlib-analogist` on Mathlib's Serre-duality coverage for smooth proper curves BEFORE scheduling Phase B.

### Mid-term — Phase C1 (`LineBundle` refactor)

Refactor subagent: rewrite `Picard/LineBundle.lean` body from `CommRing.Pic Γ(X, ⊤)` to `MonoidalCategory.Invertible (X.Modules)`. Protected signature stays. **Promotion trigger fired iter-107**; either fires this iter (under Option (ii) escape-valve) or is on standard schedule slot (~iter-111+ after Phase B starts) under Option (i) escape-valve.

### Mid-term — Phase C2 (`PicardFunctor` re-derivation)

Re-derive `PicardFunctor`'s `quotMap`/`fiberMap`/etale-sheafification against the new `LineBundle`. Estimate 4–6 iters / ~150 LOC. Sequenced after C1.

### Phase C3 — DEFERRED via `JacobianWitness` exit policy

See "Phase C3 exit policy" section above.

## Soundness rule

**No helper lemma with a universally-false signature may be introduced**, even with a `sorry` body. Such a helper is logically an axiom; combined with `exact ... _` applications, it bypasses any subsequent goal.

When the genuine statement is impossible to prove because of a Mathlib gap, the project's choice is between:
(a) Leave the inline `sorry` in place at the use site (preferred — surfaces honest status).
(b) Define an iff-form helper as a `theorem ... : iff_statement := sorry` if the statement is mathematically TRUE.

Never replace an inline `sorry` with a `sorry`-bodied helper that strengthens the claim.

The **Phase C3 exit policy** above is the soundness-rule-compliant treatment of an unbounded Mathlib gap.
```

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

| Chapter | One-line topic |
|---|---|
| `AbelJacobi.tex` | Abel–Jacobi morphism `C → Jac(C)` and uniqueness; protected `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`. |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris LES for `HModule`; Čech-acyclicity machinery; `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is the load-bearing theorem currently under Phase A construction. |
| `Cohomology_SheafCompose.tex` | `hasSheafCompose` for additive functor composition. |
| `Cohomology_StructureSheafAb.tex` | Abelian-sheaf structure on `O_X` and Ext-based H¹. |
| `Cohomology_StructureSheafModuleK.tex` | Module-over-k structure on the structure sheaf; `module_finite_globalSections_of_isProper`; downstream HModule_Hom_Finite. |
| `Differentials.tex` | Cotangent sheaf `Ω^1_{X/k}`, universal derivation, cotangent exact sequence; `serre_duality_genus`; 5 sorries (Phase B). |
| `Genus.tex` | `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`; closed iter-011. |
| `Jacobian.tex` | `Jacobian C` and the four protected instances (`grpObj`, `smooth`, `proper`, `geomIrred`); `JacobianWitness` exit policy + the `nonempty_jacobianWitness` sorry. |
| `Modules_Monoidal.tex` | `MonoidalCategory X.Modules`; `instIsMonoidal_W` (deferred Mathlib gap). |
| `Picard_Functor.tex` | `PicardFunctor` (sheafified Pic) and `representable` (deferred). |
| `Picard_FunctorAb.tex` | AddCommGrp-flavor Picard functor; étale sheafification. |
| `Picard_LineBundle.tex` | `LineBundle X` definition; pull-back functoriality. **Currently approximating `LineBundle X := CommRing.Pic Γ(X, ⊤)`** (admitted-wrong on non-affine schemes by its own docstring; carries iter-104+ critical lean-auditor flag; C1 promotion path documented). |
| `Rigidity.tex` | `GrpObj.eq_of_eqOnOpen`. |

## Prior critique status

- **strategy-critic-iter107** returned 2 must-fix items (both addressed in iter-107 plan):
  - (a) Add an explicit single-further-iter budget on L1802 to prevent the binary "close or stall" framing from smuggling in indefinite continuation. **ADDRESSED**: STRATEGY.md § "Phase A escape-valve menu" now binds the iter-110 escape-valve as MANDATORY on second consecutive PARTIAL.
  - (b) Add **defer-L1846-as-named-Mathlib-gap** as a third option alongside "close L1846" and "fire C1 promotion" in the iter-110+ escape-valve menu. **ADDRESSED**: STRATEGY.md § "Phase A escape-valve menu" now lists Options (i)/(ii)/(iii) with defer-as-gap as Option (i) DEFAULT.
  - Also raised: variance flag on `serre_duality_genus`. **CARRIED**: still in the Phase B row, not yet actionable (Phase B not dispatched).

- **strategy-critic-iter106** returned 2 challenges (both addressed in iter-106 plan):
  - (a) Plain-language end-state disclosure (Jacobian framework conditional on `nonempty_jacobianWitness` ≠ Jacobian constructed). **ADDRESSED**: STRATEGY.md § "End-state" now carries the plain-language disclosure paragraph.
  - (b) Pivot from L1120 sunk-cost slot. **ADDRESSED**: L1120 paused per progress-critic STUCK; Phase A pivoted to L1846.

- **strategy-critic-iter105** returned REJECT on Phase C3. **ADDRESSED**: JacobianWitness exit policy adopted iter-107.

The plan agent is asking the iter-108 critic to re-verify whether the strategy as stated, with the iter-107 amendments and the iter-110 escape-valve menu firing this iter, is still SOUND for a fresh-context reader. Specifically: is it acceptable for the project's end-state to potentially carry **4 named Mathlib-gap sorries** instead of 3, if Option (i) (defer L1846 as gap) wins the escape-valve? Or does that expansion of the named-gap surface fundamentally change the project's value-proposition in a way that argues for Option (ii) (fire C1 promotion) even though it doesn't help L1846 specifically?
