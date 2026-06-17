# Strategy Critic Directive

## Slug
iter142

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`): `AlgebraicGeometry.genus`
(in `Genus.lean`); `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`,
`Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`,
`Jacobian.instGeometricallyIrreducible` (all in `Jacobian.lean`);
`Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp` (all in `AbelJacobi.lean`). All nine
signatures are frozen by the mathematician. The terminal output target is
`nonempty_jacobianWitness` which quantifies over an arbitrary smooth proper
geometrically irreducible curve `C` over `k` (no genus parameter and no
`k`-rational-point hypothesis — Brauer–Severi conics over `ℚ` rule out any
`C ≅ ℙ¹_k` shortcut). The body must close via a genus case-split
(`by_cases h : genus C = 0`) into `genusZeroWitness` (M2) and
`positiveGenusWitness` (M3).

## Strategy under review

# Strategy

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them. Importantly, `nonempty_jacobianWitness` quantifies over an
arbitrary curve `C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]`
— no genus parameter, no $k$-rational-point hypothesis. Any sub-strategy
that depends on `C(k) ≠ ∅` (notably `C ≅ ℙ¹_k`) is mathematically false
on the protected signature (Brauer–Severi conics over `ℚ` are
counterexamples) and must be handled by base change.

## End-state (iter-121 pivot)

Prior iterations operated under a "ship with one inline `sorry`" end-
state, treating each remaining Mathlib gap as project-external and
documented-but-deferred. **Per the iter-121 user directive, this framing
is dropped**: the project's autonomous loop now operates as a Mathlib
contributor, building each missing piece directly in-tree at
Mathlib-merge quality and removing the corresponding `sorry`.

The end-state is **zero inline `sorry` in the project**, with one
**explicit qualification**: **PROVISIONAL on piece (iii)
(scheme-level absolute Frobenius) closing in-tree at a tractable LOC
cost**. The piece-(iii) named-gap-sorry alternative (per
`mathlib-analogist-p1-hedge-iter138` and the iter-139 in-line
clarification) is the project's **honest fallback** if and only if
the iter-144+ scheme-Frobenius PHANTOM build (~800–1500 LOC; possibly
1200–3000 LOC per `strategy-critic-iter140` under-counting CHALLENGE)
exceeds project sustainability or returns ≥2 PARTIAL iters. **Under
fallback**: the end-state revises to *zero inline `sorry` modulo one
named-gap on scheme-level absolute Frobenius* (analogous to the
M1.d off-loop PR precedent: documented gap, upstream-PR work continues
off-loop, downstream protected chain carries one residual named-gap
identifier on a Mathlib-canonical piece). The named-gap alternative
is **NOT a stall fallback** (per iter-139) **NOR equivalent to the
named-axiom path** (rejected iter-122 by standing rule + iter-126 user
hint); it is a **provisional end-state qualification** to be re-decided
at the iter-144+ scoping-analogist gate. There are no other deferred
tasks; every other gap is on the active roadmap. The roadmap is
**multi-year wall-clock honest** (~9–24 months at sustainable
50–100 LOC/iter per `strategy-critic-iter140` arithmetic on the
17+ iter M2 critical-path + 65–180 iter M3 critical-path), decomposed
into milestones M1, M2, M3 with sub-step detail and per-step effort
estimates. Iter-by-iter `PROGRESS.md` schedules the next concrete
sub-step. **Iter-140 framing-honesty correction (per `strategy-critic-iter140`
material concern #2)**: the earlier "multi-month" language under-stated
wall-clock by 5–10×; **multi-year** is the honest framing.

## Decomposition: genus-stratified body of `nonempty_jacobianWitness`

The protected `nonempty_jacobianWitness` has signature

```
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C)
```

Although signatures are frozen, bodies are not. The plan is to
restructure the proof body as a genus case-split:

```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by milestone M2
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

`genus C : ℕ` is decidable-equality, so the `by_cases` is well-formed.
This converts M2 from "preparatory infrastructure" into an explicit
half-of-a-sorry-closure: the genus-0 sub-theorem `genusZeroWitness`
becomes a concrete Lean target. M3 is then framed as "close
`positiveGenusWitness`," which is morally what it always was.

## Current sorry inventory (iter-127)

| Site | Status | Roadmap section |
|---|---|---|
| `Differentials.lean` — `smooth_locally_free_omega` | closed iter-120 | — |
| `Differentials.lean` — bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE` | **EXCISED iter-126** (zero in-tree consumers; deletion drops the sorry; M1.d Mathlib-PR candidate preserved standalone). See § Roadmap M1 "Status: EXCISED" | § Roadmap M1 |
| `Jacobian.lean:194` — `nonempty_jacobianWitness` | open; body to be restructured into genus case-split (iter-148+) | § Roadmap M2 (genus-0 arm) + M3 (positive-genus arm) |
| `Jacobian.lean:174` — `genusZeroWitness` | **NEW iter-127 scaffold**; body gated on M2.a body iter-138+ + terminal-object instances (iter-145+) | § Roadmap M2 (M2.b row) |
| `RigidityKbar.lean:87` — `rigidity_over_kbar` (post-rename iter-128: `rigidity_over_k`) | iter-126 scaffold; body gated on shared cotangent-vanishing pile pieces (i)+(ii)+(iii), iter-128+ | § Roadmap M2 (M2.a row) + M2.body-pile (M2.d-alt renamed) |

## Roadmap

### M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart (EXCISED iter-126)

**Status: EXCISED iter-126.** The iter-126 strategy-critic CHALLENGE
on the iter-128 hard trigger ("decision iter with no new evidence
collection between now and then is sunk-cost-adjacent") was accepted.
The iter-126 plan-agent dispatched `refactor-m1-excise-iter126` THIS
iter, deleting 7 declarations from `Differentials.lean`:
`appLE_unitSubmonoid`, `appLE_colimRingHom`, `appLE_colimAlgebra`,
`appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`,
`appLE_isLocalization` (with its sorry), and the bridge
`relativeDifferentialsPresheaf_equiv_kaehler_appLE`. Net project sorry
change from the excise: 2 → 1 (the Differentials.lean parked residual
gone; only `Jacobian.lean:179` `nonempty_jacobianWitness` remains).

The M1.d Mathlib-PR candidate (`kaehler_quotient_localization_iso` —
`tensorKaehlerEquivOfFormallyEtale` generalisation to the "only base
is unramified" case) **stays in the tree as a standalone utility**
along with its supporting lemma `kaehler_localization_subsingleton`.
The PR-extraction work continues off-loop from
`analogies/relative-differentials-presheaf-bridge.md`.

The pre-bridge definitions `relativeDifferentialsPresheaf` and
`relativeDifferentialsPresheaf_obj_kaehler` (the rfl identification
lemma) stay in the tree as standalone infrastructure (independently
useful for any future scheme-side cotangent presheaf consumer; not
load-bearing for any current Lean target).

**Why excise over close.** Strategy-critic iter-126 made the call
concrete:
- M1 bridge has **zero in-tree consumers** (verified iter-125;
  re-verified by the refactor's grep before deletion).
- M1.d is the only extractable Mathlib-PR piece and is **independent**
  of M1.b (which is admitted to be "too scheme-morphism-shaped for
  upstream PR").
- Closing M1.b (130–210 LOC of filtered-colim work) produces neither
  a downstream consumer nor an additional Mathlib PR.
- Under the iter-126 user hint "shortest path qualified by your role
  is to fill mathlib gaps", excise IS the shortest path: M1.d (the
  filled Mathlib gap) is preserved; the dead-weight sorry departs.

The iter-128 hard trigger no longer fires (the decision has been
made iter-126).

**Standalone Mathlib-PR candidate (preserved in-tree).** The M1.d
declaration `kaehler_quotient_localization_iso` in `Differentials.lean`
remains as a standalone utility post-excise. Statement: for an
algebra tower `A → L → B` where `A → L` is a localization at a
submonoid `M ⊆ A`, the natural map `Ω[B⁄A] → Ω[B⁄L]` is a
`B`-linear equivalence. Built via Mathlib's
`KaehlerDifferential.map A L B B` + `LinearEquiv.ofBijective` using
`KaehlerDifferential.exact_mapBaseChange_map` +
`KaehlerDifferential.map_surjective` + the
`Subsingleton Ω[L⁄A]` consequence of `Algebra.FormallyUnramified.of_isLocalization`.
Generalises `tensorKaehlerEquivOfFormallyEtale` to the "only base is
unramified" case. Detailed design in
`analogies/relative-differentials-presheaf-bridge.md`. Off-loop
upstream-PR work proceeds from that file; the in-tree declaration
is the working version for the PR.

### M2 — Genus-0 witness sub-theorem `genusZeroWitness`

**Estimated cost (revised iter-128 per `strategy-critic-iter128` honest piece-(iii) accounting).** **9–20 iter / 1850–3600 LOC** for the shared pile (pieces (i)+(ii)+(iii); piece (iv) deferred). M2.c and M2.c.aux remain DROPPED iter-127 (the over-k analogist's OK_OVER_K verdict on all three pieces is unchanged), eliminating the Galois-descent step; however the piece-(iii) honest LOC is revised from 300–600 to 800–1500 (no scheme-level Frobenius in Mathlib `b80f227`; Stacks Tag 0CC4 is the canonical reference for the build). **Net savings vs over-`k̄`+M2.c baseline (revised): 2–6 iter / 0–500 LOC** (the over-k commitment remains net-positive but the case is narrower than iter-127's framing).

**Statement.** Let `C` be a smooth proper geometrically irreducible
curve over a field `k` with `genus C = 0`. Then there exists a
`JacobianWitness` for `C` whose underlying scheme is `Spec k`.

**Iter-127 strategic update (over-k path COMMITTED).** Prior strategy
iterations routed through base-change to the algebraic closure `k̄`
followed by Galois descent (M2.c, ~300–500 LOC; M2.c.aux
`geomIrred.exists_kalg_pt`, ~200–400 LOC). The iter-127 over-k
analogist (`analogies/cotangent-vanishing-pile-over-k.md`) verified
that pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile
build directly over an arbitrary base field `k`:

- Piece (i) cotangent triviality is intrinsic — the shear iso
  `(a, b) ↦ (a, a·b)` is a scheme map over any base; no $k̄$-rational
  points needed; mulRight-globalisation formulated functorially.
- Piece (ii) `Differential.ContainConstants` is k-agnostic in Mathlib
  (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:62–66`); the
  project's `Scheme.Over.ext_of_eqOnOpen` is already over `[Field k]`.
- Piece (iii) `frobenius R p` / `iterateFrobenius R p n` work over any
  char-p ring; Frobenius iteration uses **absolute** Frobenius (intrinsic
  to `X`), not relative Frobenius (which would need perfectness).

Net effect: the iter-126 `rigidity_over_kbar` named declaration is
already k-agnostic in its signature (`[Field kbar]`, no
`[IsAlgClosed kbar]`); only docstrings, variable name (`kbar` → `k`,
deferred to iter-128+ rename refactor), and blueprint framing need to
shift to the over-k reading. **M2.c (Galois descent of morphism
equality) and M2.c.aux (`geomIrred.exists_kalg_pt` PHANTOM) are
removed from M2's critical path.**

For the genus-0 universal property of `J = Spec k`:

- If `C(k) ≠ ∅`: pick a marked point `P ∈ C(k)`. The over-k rigidity
  `rigidity_over_k` (post-rename) applies directly with `f : C → A`
  and `P` as the $k$-rational pointing; the conclusion
  `f = toUnit C ≫ η[A]` is exactly the universal-property
  factorisation.
- If `C(k) = ∅` (Brauer–Severi conics over `ℚ` are the standard
  counterexample): `IsAlbanese C P J` is **vacuously satisfied** for
  every `P`. **Vacuity-branch verification (response to
  `strategy-critic-iter127` CHALLENGE on M2.b)**: the `JacobianWitness`
  field `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P J`
  (`Jacobian.lean:160`) is genuinely universally quantified — Lean's
  `∀ P, IsAlbanese …` is vacuously true at the type level when the
  type `𝟙_ _ ⟶ C` is empty (no `k`-rational points). The vacuity
  branch is sound on the protected signature.

**Decomposition (iter-127, over-k variant COMMITTED).**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M2.a | Rigidity for morphisms from a smooth proper geometrically irreducible curve of `genus = 0` to a smooth proper geometrically irreducible group scheme `A`, **over an arbitrary base field `k`** (post-iter-127 over-k commitment). The iter-126 scaffold's Lean signature is already k-agnostic: `[Field kbar]` (no `[IsAlgClosed kbar]`); only the variable name `kbar` and docstrings frame it as over-`k̄`. The rename `rigidity_over_kbar` → `rigidity_over_k` is **DEFERRED to iter-129+** as a cleanup refactor (low priority; signature unchanged). **Iter-126's scaffold deliverable**: named declaration with `sorry` body whose only residual reduces to the shared cotangent-vanishing pile (C.2.d phantom). C.2.b reduction + C.2.c image-dimension dichotomy CAN sit in the body around the sorry; what CANNOT close without the pile is the positive-dim branch of C.2.c (which routes into C.2.d). The true M2.a body closure is gated on the shared cotangent-vanishing pile and lands iter-145+ (revised post-iter-128). **`strategy-critic-iter128` CHALLENGE absorbed**: the over-k C.2.b prose ("we will take `U := ℙ¹_{k̄}`") and C.2.c image-dimension argument (residue-field-extension handling at closed points of `C`) are blueprint-prose-cleanup soon-items scheduled for iter-129+; the body closure path bypasses C.2.b/C.2.c entirely via the differential-vanishing route (pieces (i)+(ii)+(iii)), so the stale prose does NOT block the iter-128+ shared-pile build. | The project's `Scheme.Over.ext_of_eqOnOpen` (post-iter-125 refactor, already over `[Field k]`); shared cotangent-vanishing pile (see M2.d-alt). | iter-126: ~1 iter / 87 LOC for the scaffold-and-named-sorry (DONE); iter-129+ rename refactor +5 LOC; +9–20 iter shared pile (counted under M2.body-pile, not double-counted here; revised iter-128). |
| M2.b | Genus-0 witness for `Spec k`: define `genusZeroWitness C h` where `h : genus C = 0`, returning a `JacobianWitness C` with underlying scheme `Spec k`, trivial group structure, smoothness of relative dimension 0 (matching `genus C = 0`), and `isAlbaneseFor` field's substantive content via `rigidity_over_k` (post-rename; iter-126 `rigidity_over_kbar` until then) on the C(k) ≠ ∅ branch + vacuity on the C(k) = ∅ branch. **Iter-127 scaffold landed** (`Jacobian.lean:174–178`): single `sorry` body. The body closure is gated on the M2.a body (iter-138+) and lands iter-145+. | New project material; consumes `rigidity_over_k` once its body closes. | iter-127: ~1 iter / ~20 LOC for the scaffold-and-named-sorry (DONE); body closure +1 iter / +100–200 LOC. |
| ~~M2.c~~ | **DROPPED iter-127** per `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` OK_OVER_K verdict. Originally: Galois-descent of morphism equality of schemes (300–500 LOC / 4–8 iter). Under the over-k path the descent is unnecessary because pieces (i)+(ii)+(iii) build directly over k. | n/a | **eliminated**: −4–8 iter / −300–500 LOC. |
| ~~M2.c.aux~~ | **DROPPED iter-127**. Originally: `geomIrred.exists_kalg_pt` PHANTOM (200–400 LOC / 3–5 iter). Eliminated under the over-k path because no base-change-to-`k̄` is performed. | n/a | **eliminated**: −3–5 iter / −200–400 LOC. |
| M2.d (RR path; **NOT ACTIVE**) | Genus-0 identification `C ≅ ℙ¹_k` over k (only relevant for C(k) ≠ ∅) via Riemann–Roch. **Status (iter-127)**: M2.d is no longer on the critical path. The over-k rigidity argument routes through cotangent-vanishing (M2.d-alt's pile pieces (i)+(ii)+(iii)) without requiring the literal `C ≅ ℙ¹_k` identification. M2.d is documented here only as a fallback if M2.d-alt's pile cannot close. Per `strategy-critic-iter127` CHALLENGE on Serre-duality cost-accounting reconciliation: **the prior 1500–3000 LOC estimate was internally inconsistent** with the standalone Serre-duality estimate of 3000–8000 LOC (per `analogies/serre-duality.md` iter-110 verdict). The reconciled honest estimate, if M2.d were activated, would be **15–25 iter / 3000–8000 LOC (Serre duality dominates)** + 500–1500 LOC for the other RR sub-steps. NOT relevant under iter-127's over-k commitment. | Mathlib gap on every sub-step; Serre duality is the dominant standalone gap. | NOT ACTIVE. |
| M2.d-alt → **renamed M2.body-pile** iter-127 (per `strategy-critic-iter127` CHALLENGE: piece (iv) deferral foreclosed the original "genus-0 identification" arm; the pile now covers only M2.a body, not genus-0 identification) | **Cotangent-vanishing rigidity pile** — gates M2.a body closure (C.2.d). The pile (pieces (i)+(ii)+(iii)) is the iter-128+ shared build: (i) **group-scheme cotangent triviality** as `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` (per `cotangent-vanishing-pile-iter126` analogist naming-idiom alignment — Mathlib `b80f227` has no `AbelianVariety` file; `GrpObj` namespace per Yang+Merten 2026); (ii) **scheme-level df=0 ⇒ factors-through-Spec-k** as `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (ring-level half aligns with Mathlib `Differential.ContainConstants`); (iii) **char-`p` Frobenius iteration** (committed Option A per iter-126 analogist; uses absolute Frobenius `F_X`, not relative). **Piece (iv) Serre duality DEFERRED** as named-gap; **the deferral forecloses any "genus-0 identification" use case** of the pile. The pile under iter-127's over-k commitment covers ONLY M2.a body closure. **Iter-129 must-fix on iter-128 close**: the landed `AlgebraicGeometry.GrpObj.lieAlgebra` declaration's signature hardcodes `[SmoothOfRelativeDimension 1 G.hom]`; per `strategy-critic-iter129` + `lean-vs-blueprint-checker-cotangent-grpobj-review128` this must be relaxed to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` so the downstream consumer `rigidity_over_kbar` (applied to abelian variety of arbitrary relative dimension) can instantiate it. Refactor lane scheduled iter-129 (`refactor-cotangent-grpobj-fixup-iter129`). **Iter-129 must-fix on chosen body presentation**: per `strategy-critic-iter129` CHALLENGE on the presheaf-vs-sheaf bridge, the rank lemma `lieAlgebra_finrank_eq_dim` consumes either (a) a sheaf-vs-presheaf-top-sections coincidence theorem for proper `GrpObj` (which the project must build), or (b) an isomorphism between the iter-128 evaluate-then-extend-scalars body and the cotangent-at-stalk `𝔪/𝔪²` via `IsLocalRing.CotangentSpace` (the verified Mathlib name; the earlier blueprint `IsRegularLocalRing.cotangentSpace` is a phantom that must be corrected). The iter-129 mathlib-analogist-`lieAlgebra-rank-bridge-iter129` will scope this bridge cost; piece (i.b)/(i.c) LOC may rise from the bundled 800–1500 toward the lower end of (800 + 500–1000 bridge) = 1300–2500 if ALIGN_WITH_MATHLIB fires (standalone cotangent-sheaf detour). | Mathlib: `AlgebraicGeometry.GrpObj.omega_*` PHANTOM; `Mathlib.RingTheory.Derivation.DifferentialRing` `ContainConstants` typeclass (verified) for piece (ii) ring-level alignment; `Mathlib.Algebra.CharP.Frobenius` for ring-level Frobenius; **scheme-level absolute Frobenius `F_X` is a substantial Mathlib gap with NO precedent in `b80f227`** (per `strategy-critic-iter128` CHALLENGE; `lean_local_search` "Frobenius" returns only ring-side `Mathlib.Algebra.CharP.Frobenius` + `NumberTheory.FrobeniusNumber`; no `AlgebraicGeometry.Scheme.frobenius`); `IsLocalRing.CotangentSpace` (verified, replaces the earlier phantom `IsRegularLocalRing.cotangentSpace`) for the stalk-side cotangent of the rank lemma. | **Pile (i)+(ii)+(iii) total (iter-128 revised): 1850–3600 LOC over 9–20 iter** (piece (i) 800–1500 LOC / 5–10 iter; piece (ii) 250–500 LOC / 2–3 iter; piece (iii) **revised 800–1500 LOC / 4–7 iter** per `strategy-critic-iter128` honest-LOC accounting on the missing scheme-level Frobenius); piece (iv) DEFERRED (n/a). The over-k path still nets net savings vs. over-`k̄`+M2.c because Galois-descent of morphism equality (M2.c, 4–8 iter / 300–500 LOC) is eliminated; but the over-k savings drop from "7–13 iter / 500–900 LOC" to **"2–6 iter / 0–500 LOC"** under the revised piece (iii) accounting. **Iter-129 mathlib-analogist verdict gates further revision: ALIGN_WITH_MATHLIB triggers a standalone-cotangent-sheaf detour (~500–1000 LOC) which could push piece (i) toward the 1300–2500 LOC range and push the over-k net savings to negative.** |

**Sub-step dependency (iter-127, over-k path)**: M2.b depends on M2.a (rigidity over k). M2.a body depends on the shared pile (pieces (i)+(ii)+(iii)). The chain is linear: pile (i) → pile (ii) → pile (iii) → M2.a body → M2.b body closure → genus-stratified body of `nonempty_jacobianWitness`.

**Standalone-cotangent-sheaf alternative (per `strategy-critic-iter127` critical alternative).** The iter-126 analogist's piece (i) decomposition bundles a "presheaf-vs-sheaf bridge cost" into its 800–1500 LOC estimate. The strategy critic proposes treating the **scheme-level cotangent sheaf** as a standalone Mathlib-PR target ahead of piece (i), with two claimed benefits: (a) the cotangent sheaf is independently useful Mathlib infrastructure (consumed by RR, smoothness criteria, surface theory); (b) front-loading it would reduce piece (i)'s estimate from 800–1500 LOC to ~400–800 LOC.

**Plan-agent verdict (iter-127): DEFER, do not unbundle now.** The presheaf-level path is already committed via the project's existing `relativeDifferentialsPresheaf` and is consistent with the iter-126 analogist's bundled estimate. Unbundling would: (i) require dispatching a separate analogist to scope the cotangent-sheaf gap precisely; (ii) delay piece (i) by 5–8 iter; (iii) introduce a parallel-build coordination cost. Under the iter-126 user hint ("do the work; shortest path among legitimate options"), the bundled path is shorter even if individually less PR-clean. **Revisit at iter-129 if piece (i) build reveals the bridge cost is substantially worse than estimated.** If the bridge alone exceeds 500 LOC during iter-129+ build, dispatch a follow-up analogist on the standalone cotangent-sheaf alternative.

**Iter-129 trigger fired and RESOLVED (`strategy-critic-iter129` + `mathlib-analogist-lieAlgebra-rank-bridge-iter129`):** the iter-127-scheduled re-evaluation completed this iter. Verdict: **ALIGN_WITH_MATHLIB on the iter-128 body** (it collapses to zero for the target class; mathematically wrong), but **PROCEED on the bundled-vs-unbundled decision** (Replacement (B) chart-base-change body keeps the project on the bundled 800–1500 LOC piece (i) estimate without sheafifying). The standalone scheme-level cotangent-sheaf alternative (Replacement (C)) is NOT activated. See § "Direct over-k rigidity" ▸ "Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned" above for the full verdict and the iter-130 body-swap directive.

**Serre-duality cost-accounting reconciliation (per `strategy-critic-iter127` critical alternative).** Prior STRATEGY.md had Serre duality buried inside M2.d's 1500–3000 LOC total AND named standalone in the M2.d-alt piece (iv) at 3000–8000 LOC. These were inconsistent. Reconciled iter-127:

- **Serre duality is a shared top-level dependency** consumed by (a) M2.d (RR path; fallback, NOT ACTIVE under over-k commitment); (b) M2.d-alt piece (iv) (genus-0 identification arm; DEFERRED under iter-127's over-k commitment).
- Honest standalone estimate: **3000–8000 LOC** per `analogies/serre-duality.md` iter-110 verdict.
- Status under iter-127's over-k commitment: **NOT NEEDED for M2.a body closure** (the pile is (i)+(ii)+(iii) only). Serre duality re-enters the project's critical path only if M2.d-alt piece (iv) is needed for some future genus-0 identification statement that the over-k rigidity does not subsume.

### M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

**`positiveGenusWitness` scaffold — LANDED iter-134** (per `strategy-critic-iter132` minor alternative re-raised by `strategy-critic-iter134`). Stub `positiveGenusWitness C (hg : 0 < genus C)` declaration landed in `AlgebraicJacobian/Jacobian.lean:194–215` (~21 LOC including docstring) parallel to the iter-127 `genusZeroWitness` scaffold; `sorry` body. Dispatched via `refactor-positiveGenusWitness-scaffold-iter134` (~+25 LOC, compiles clean, sorry count 3 → 4). Effect: both genus arms of the planned `by_cases h : genus C = 0` decomposition of `nonempty_jacobianWitness` are now scaffolded (`genusZeroWitness` since iter-127; `positiveGenusWitness` since iter-134), so the genus-stratified body restructure precondition is met. The body restructure itself remains iter-157+ work (gated on M2.b body close + M3 scaffold landing here). The closure of `positiveGenusWitness` body is M3 work (off-critical-path; user-escalation-pending per `analogies/m3-route-audit.md`); the new sorry adds to the off-critical-path scaffold inventory, not the iter-by-iter critical path.

**Estimated cost.** 100+ iter / 10000+ LOC per route; honest figure
per strategy-critic-iter122. Both Route A (Picard scheme via FGA) and
Route B (symmetric powers + Stein) require multi-thousand-LOC
contributions to Mathlib for each of their top-3 gating pieces. Per
the existing route-pick decision criterion's "hard fallback" rule
(LOC > 5000 of upstream-Mathlib work ⇒ user-escalate), **user
escalation is the correct action once the route-pick audit fires**;
the audit can run independently of M1 (it is a Mathlib namespace scan
+ LOC estimate, not Lean proof work).

**Iter-123 M3 route-pick audit result.** `mathlib-analogist-m3-route-audit-iter123`
returned per-piece LOC estimates against Mathlib snapshot `b80f227`:
Route A midpoint **~6500 LOC** (A1 Hilbert+QCoh/Coh/flattening ~4150 LOC;
A2 Quot post-A1 ~1400 LOC; A3 identity-component subgroup scheme
~1025 LOC). Route B midpoint **~9000 LOC** (B1 `Sym^n` of schemes
~3075 LOC; B2 Stein factorisation ~2800 LOC; B3 RR + Brill-Noether
~3450 LOC). **Both routes exceed the 5000-LOC hard-fallback
threshold; user escalation is triggered for iter-124.**
Route A preferred on cross-utility (Hilbert/Quot/identity-component
are top-tier Mathlib infrastructure) and LOC (~2500 LOC lower at
midpoint). Three smallest extractable upstream-PR pieces (each <1500
LOC, useful regardless of route): Relative Spec functor (~700–1100
LOC; **top recommend** — strict prerequisite for Stein, useful for
affine-map factorisation in any FGA setup), identity-component of
`k`-group scheme (~850–1200 LOC; needed by both routes), QCoh+Coh
typeclass on `Scheme.SheafOfModules` (~700–900 LOC; foundational
for every downstream coherent-sheaf theorem). Persistent file:
`analogies/m3-route-audit.md`.

**Statement.** Let `C` be a smooth proper geometrically irreducible
curve over `k` with `genus C ≥ 1`. Then there exists a
`JacobianWitness` for `C` whose underlying scheme is the Albanese
variety of `C` (i.e. the connected component of the identity of
`Pic_{C/k}`, or equivalently the Stein factorisation of the
Abel–Jacobi morphism on `Sym^g(C)`).

**Two equally hard routes.** The project will pick one route after
M1 closes and the project audits Mathlib's then-current snapshot
against each route's gating dependencies.

#### Route A — Picard scheme via FGA

Hilbert schemes, Quot schemes, representability of the Picard
functor for smooth proper geometrically connected curves,
identity-component construction.

**Top-3 gating Mathlib pieces** (each is itself a multi-thousand-LOC
contribution candidate):

1. **Hilbert scheme representability for projective schemes**:
   `Mathlib.AlgebraicGeometry.Hilbert.Representability` (doesn't
   exist). Decomposes into (a) the Hilbert functor as a functor
   $(\Sch/k)^{\mathrm{op}} \to \Sets$, (b) the representability theorem
   via Grothendieck's flattening stratification, (c) the
   smoothness/properness of the Hilbert scheme on smooth projective
   bases.
2. **Quot scheme representability**: representability of the Quot
   functor of coherent quotients on a proper scheme. Generalises
   Hilbert; depends on coherent-sheaf-of-finite-type infrastructure
   that is partially in Mathlib.
3. **Identity-component construction `G^0 ⊆ G`**: for a $k$-group
   scheme `G` locally of finite type, the connected component of the
   identity as a closed (and open) subgroup scheme. Requires
   `IsConnectedSpace` for the identity component, plus the topological
   connectedness of identity components of group objects in `Scheme/k`.

#### Route B — Symmetric powers + Stein factorisation

Scheme-level symmetric powers, finite-group-scheme quotients,
Brill–Noether–Riemann–Roch, Stein factorisation.

**Top-3 gating Mathlib pieces**:

1. **Symmetric powers of schemes `Sym^n X` with smoothness**:
   `Mathlib.AlgebraicGeometry.SymmetricPower` (doesn't exist).
   Requires the finite-group-quotient construction `X^n / S_n` with
   smoothness when `X` is smooth (Fogarty's symmetric-product
   computation).
2. **Stein factorisation theorem**: for a proper morphism
   `f : X → Y` of locally Noetherian schemes, $f_* \mathcal O_X$ is a
   coherent $\mathcal O_Y$-algebra and $f$ factors as
   $X \to \mathrm{Spec}_Y(f_*\mathcal O_X) \to Y$. Requires coherent
   $\mathcal O$-module cohomology of proper morphisms (partially in
   Mathlib).
3. **Brill–Noether and Riemann–Roch**: as for M2.d, the curve-side
   Riemann–Roch input is the largest Mathlib gap; absent from
   Mathlib in usable form for the project's genus-via-Ext
   definition.

#### Route-pick decision criterion

**Trigger** (revised iter-122 per strategy-critic-iter122). The
Mathlib-coverage audit is an offline LOC estimation that does NOT
depend on M1 closure. **Schedule: iter-123** (immediately after the
iter-122 M1 work returns its first results, regardless of whether
M1 closes; the audit is a parallel deliverable, not a sequential
gate). The route is "picked" once the audit returns its honest LOC
totals.

**Criterion.** Run a Mathlib coverage audit of each route's top-3
gating pieces. For each missing piece, estimate the project-internal
LOC required to build it (the typical multi-K LOC contribution). Pick
the route with the smaller cumulative LOC estimate. **Tiebreaker**:
if estimates are within 20% of each other, prefer the route whose
top-3 gating pieces have the most cross-utility outside the Jacobian
arc (the Hilbert/Quot/representability infrastructure of Route A has
broader downstream value; the symmetric-power / Stein machinery of
Route B is more curve-specific). **Hard fallback**: if both routes
exceed 5000 LOC of estimated upstream-Mathlib work, escalate to the
user for an external-PR routing decision (likely: post an upstream
PR for at least the smallest gating piece and continue on the
remaining routes-and-arms while waiting).

#### Per-iter progress signal for M3

During M3's multi-iter run, the progress signal is:

- **Iter $N$ "on track" criteria**:
  1. At least one named gating piece has its scaffolding declaration
     (with `sorry` body) introduced or its body partially closed.
  2. The cumulative LOC against the route's bill-of-materials
     decreases or stays flat (an iter that ADDS LOC to the BOM is
     CHURNING; the route is on a deeper gap than estimated).
  3. The cumulative `\leanok`-tagged declarations across the BOM
     increases by at least one per 2 iters (otherwise CHURNING).
- **Iter "off track" signal**:
  1. Two iters in a row introduce a new helper declaration whose
     blueprint chapter doesn't yet exist (blueprint expansion is
     overdue).
  2. The prover lane on the BOM's smallest piece returns INCOMPLETE
     twice consecutively (the piece is too tightly coupled to
     Mathlib infrastructure; pivot strategy or escalate to user).

## What ships unconditionally (current snapshot)

These files compile end-to-end with no `sorryAx` in their axiom chains
as of iter-120 close:

- `Rigidity.lean` — Mumford rigidity for pointed proper smooth morphisms.
- `Genus.lean` — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Cohomology/SheafCompose.lean` / `StructureSheafAb.lean` /
  `StructureSheafModuleK.lean` / `MayerVietorisCore.lean` /
  `MayerVietorisCover.lean` — the Čech / Mayer–Vietoris infrastructure
  consumed by `Genus.lean`.
- `Differentials.lean` (current declarations) —
  `relativeDifferentialsPresheaf` definition,
  `relativeDifferentialsPresheaf_obj_kaehler` identification,
  `smooth_locally_free_omega` forward direction (algebra-Kähler form).
  The bridge declaration `relativeDifferentialsPresheaf_iso_kaehler_appLE`
  introduced by iter-121 will hold a `sorry` body during M1.

The protected `genus` and `Rigidity` are unconditional.

## What ships against the genus case-split (current snapshot)

The protected `Jacobian`-arc declarations (`Jacobian.lean` +
`AbelJacobi.lean`) all `lean_verify` to `sorryAx` rooted at
`Jacobian.lean:179`. Once M2 lands `genusZeroWitness` and M3 lands
`positiveGenusWitness`, the genus-stratified body of
`nonempty_jacobianWitness` closes the chain. Until then, the framework
around the Albanese variety (group-object structure, smoothness of
relative dimension `g`, properness, geometric irreducibility, the
Abel–Jacobi map, and the universal property) ships against the
witness existence.

## Soundness rules

- **No new axioms.** Every closed declaration must `lean_verify` to
  kernel-only axioms (`propext, Classical.choice, Quot.sound`). The
  iter-122 strategy-critic raised an alternative end-state of
  promoting `nonempty_jacobianWitness` to a named project `axiom`
  (signature unchanged, the protected chain `lean_verify`s to one
  named project axiom + kernel axioms). **This alternative is ruled
  out by the plan-agent standing instruction in `prompts/plan.md`
  ("You should NEVER propose adding new axioms")** AND **reaffirmed
  by the iter-126 user hint** ("no good reason to tell me … to add
  an axiom or not do the work (this is laziness, not a good reason);
  ~6500–9000 LOC may not be that much for an AI"). The plan-agent
  hard rule is a project-wide standing rule and the user hint is the
  iter-by-iter reaffirmation; together they remove the named-axiom
  alternative from every milestone (M1 disposal, M3 escalation, any
  future). The loop's exit from any Mathlib gap is the
  do-the-Mathlib-work path, however long.
- **User-hint citation discipline (per `strategy-critic-iter128` sunk-cost flag).** The iter-126 user hint "do the work, no axioms; ~6500–9000 LOC may not be that much for an AI" was issued in the specific context of the **M3 user-escalation TO_USER banner** (M3 Route A vs axiomatising `nonempty_jacobianWitness`); it is NOT a generic blanket warrant for *all* expensive in-tree paths. When this strategy invokes the user hint, it must cite the *specific* decision the hint applies to. Each in-tree expensive build (e.g. scheme-level absolute Frobenius for piece (iii)) must justify itself **on the merits of the local LOC/iter trade-off** vs alternatives, not by appeal to the user hint as a blanket. The hint remains binding *on its actual scope* (M3 disposition + the no-axiom rule generally); reasoning that smuggles new scope under it is sunk-cost.
- **LOC trigger arm renormalisation discipline (added iter-138 per `strategy-critic-iter138` sunk-cost flag #2; SYMMETRY AMENDMENT iter-141 per `strategy-critic-iter141` must-fix #3).** LOC-based trigger arms (the (a')/(c) revert cap, the fibre-free pivot threshold, etc.) **may renormalise ONLY when a NEW analogist consult justifies a new LOC envelope** (as iter-137's `kaehler-tensorequiv-presheafpullback-iter137` consult did, widening Step 2 from 150–300 LOC to 360–710 LOC). Renormalising on the basis of a prover lane reporting growing LOC without a new analogist re-scope is moving-goalpost and forbidden: "we always raise the cap to fit the envelope" is no trigger at all. Once a new envelope is justified by an analogist consult, **all dependent trigger arms (revert cap, pivot threshold, slip watchpoint) renormalise together with documented arithmetic**; partial renormalisation that tightens one trigger while leaving an arithmetically-adjacent one fixed is sunk-cost-shaped and equally forbidden. **Symmetric direction (iter-141)**: renormalisation discipline applies to BOTH up-and-down adjustments. **When a piece closes materially under its envelope (≥30% under the envelope midpoint), the dependent caps tighten proportionally to "realised LOC + 30% slack"**, regardless of whether the close was within budget. The previous text only ratcheted the cap up; absent symmetric tightening, the LOC arm is a one-way ratchet that partially undoes the iter-138 sunk-cost-flag-#2 prevention over time. Both directions of renormalisation must be documented with arithmetic showing the new cap = realised-LOC × (1 + slack). The slack rate (30%) is fixed; widening it would itself be a renormalisation-discipline violation.
- **Analogist-overhead axis on M2.body-pile cost accounting (added iter-139 per `strategy-critic-iter139` Must-fix #6 / sunk-cost flag #2; CONSULT-COUNT ARM NARROWED iter-140 per `strategy-critic-iter140` Edit-2 CHALLENGE).** The cumulative analogist consult count per sub-piece is a route-difficulty smoke signal alongside LOC. **Threshold rule (iter-140 narrowed)**: the **envelope-widening arm fires authoritatively** — if a single sub-piece consumes ≥3 consults that each widen the envelope (NOT consult quantity alone), the route-pivot question must be re-raised on its merits with explicit strategy-critic re-dispatch (mid-iter), NOT silent absorption. The original **consult-count arm (≥5)** is **demoted to a calibration watchpoint**: it is *current-state calibration*, not a principled value (the iter-139 baseline of 4 made "5" a "fires-next-iter" calibration per the strategy-critic-iter140 challenge). The consult-count arm REVISITS to a principled value at iter-150 if it has not fired on any sub-piece by then. The iter-138 LOC renormalisation-discipline rule applies to this rule too: the consult-count threshold can renormalise only when a new analogist consult justifies a new envelope, NOT to fit an iter that crosses it without an envelope shift. **Iter-140 baseline**: piece (i.b) Step 2 carries 4 consults (iter-133 mulright-globalises, iter-135 phi-compatibility, iter-137 kaehler-tensorequiv, iter-139 IsIso-routes); only iter-137 widened (150–300 → 360–710 LOC). Iter-140 progress-critic guardrail: do NOT spawn a 5th consult mid-iter on a successful close (would pre-commit CHURNING-for-iter-141 on a CONVERGING route).
- **No "deferred" framing.** Mathlib gaps are decomposed into the
  M1/M2/M3 roadmap with concrete sub-step estimates; the planner does
  not write "out-of-autonomous-loop scope" sections anymore. If a
  sub-step is genuinely outside the loop's reach (e.g. requires a
  multi-month upstream contribution), it is recorded in the roadmap
  with an explicit "blocked on upstream X" note and a fallback
  iter-by-iter approach that progresses the surrounding sub-steps.
- **No phantom $k$-rational-point hypotheses.** The protected
  `nonempty_jacobianWitness` quantifies over arbitrary `C` without
  $k$-rational points. Sub-strategies that depend on $C(k) \neq \emptyset$
  (notably `C ≅ ℙ¹_k`) must explicitly handle the no-rational-point
  case via base change to $\bar k$ + Galois descent, or document why
  vacuity (`isAlbaneseFor` is vacuously true when $C(k) = \emptyset$)
  suffices.
- **Converse of `smooth_locally_free_omega` is mathematically false.**
  The counterexample `Spec k → Spec k[t]` via `t ↦ 0` (locally of
  finite presentation, `Ω = 0` everywhere locally free, but not flat
  hence not smooth) breaks the bare local-freeness-of-Ω implication.
  The true converse needs `Subsingleton (Algebra.H1Cotangent A B)`
  (formal smoothness via vanishing André–Quillen `H¹`). The blueprint
  chapter `Differentials.tex` discloses this; we do not state the
  false iff. The Mathlib converse-lemma
  `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` `[verified]`
  exists with these extra hypotheses; an optional future M4 milestone
  may wire it up as a scheme-level converse-with-extra-hypothesis
  result if a downstream consumer needs it.

## Mathlib gap inventory (live, iter-127)

The roadmap above absorbs every gap previously labelled "Mathlib gap"
into a concrete milestone. For clarity:

- **Gap (bridge)**: subsumed by milestone M1 — **EXCISED iter-126**.
- **Gap (genus-0 identification `C ≅ ℙ¹_k`)**: **eliminated iter-127** under the over-k path commitment. The over-k cotangent-vanishing rigidity argument does NOT require the literal `C ≅ ℙ¹_k` identification; the genus-0 universal property is established via `rigidity_over_k` + terminal-object infrastructure directly.
- **Gap (Hilbert/Quot/FGA)**: subsumed by milestone M3 Route A,
  decomposed into top-3 gating pieces above.
- **Gap (symmetric powers / Stein factorisation)**: subsumed by
  milestone M3 Route B, decomposed into top-3 gating pieces above.
- **Gap (converse of smoothness criterion)**: optional future M4,
  driven by downstream consumer demand.
- ~~**Gap (Galois descent of morphism equality of schemes)**~~: **eliminated iter-127** — M2.c dropped under the over-k path commitment.
- ~~**Gap (`geomIrred.exists_kalg_pt` PHANTOM)**~~: **eliminated iter-127** — M2.c.aux dropped under the over-k path commitment.
- **Gap (group-scheme cotangent triviality, `GrpObj.omega_free` / `omega_rank_eq_dim` PHANTOM)**: subsumed by milestone M2.body-pile piece (i). **Iter-131 trio→duo collapse on piece (i.a)** (per `strategy-critic-iter131` Q4): under Replacement (B), the bridge lemma `lem:GrpObj_cotangent_bridge` (linking the chart-base-changed body to the canonical local-ring cotangent `𝔪 / 𝔪²`) is **not on the live build path**; it is vestigial. The piece (i.a) live trio (definition + bridge + rank) collapses to a **duo** (definition + rank lemma) under (B). The bridge lemma is now documented as **contingent on trigger (a') firing** at iter-133+ piece (i.b) — i.e., it only enters the live path if the project pivots from (B) to (A) or constructs the (B)→(A) bridge inline for piece (i.b)'s shear-iso globalisation. **Iter-133 verdict on trigger (a')**: the iter-133 mathlib-analogist (`mulright-globalises-cotangent`) returned PROCEED — the iter-131 (B)-body composes cleanly with the shear iso under the recommended **sheaf-level RHS phrasing**, and the bridge artefact piece (i.b) needs is a **chart-localisation identification** (~100–200 LOC, pushed into piece (i.c)), NOT the **(B)→(A) stalk-cotangent bridge** (~300–600 LOC) that the iter-130 strategy-critic Q2 worried about. Trigger (a') is refined: it fires only if the iter-134+ prover lane chooses **value-level-stalk RHS** phrasing for piece (i.b); with the recommended **sheaf-level** RHS, trigger (a') does NOT fire and the deferred `lem:GrpObj_cotangent_bridge` stays vestigial. Iter-132 piece (i.a) closure shipped in `AlgebraicJacobian/Cotangent/GrpObj.lean`.

- **Gap (scheme-level relative cotangent sheaf base change, `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}` PHANTOM)**: subsumed by **milestone M2.body-pile piece (i.b)** as a NEEDS_MATHLIB_GAP_FILL sub-piece (load-bearing for the shear-iso globalisation; identified iter-133 by `mathlib-analogist-mulright-globalises-iter133`). Chains `TopCat.Presheaf.pullback` with the algebra-side `KaehlerDifferential.tensorKaehlerEquiv`. Mathlib has no scheme-level relative cotangent sheaf at all (Decision 2 of `analogies/lieAlgebra-rank-bridge.md` iter-129 already noted this); piece (i.b) builds the base-change identification on top of the project's existing presheaf-level `relativeDifferentialsPresheaf`. **Status iter-133**: blueprint-writer iter-133 names this as a sub-piece of `lem:GrpObj_mulRight_globalises` in `RigidityKbar.tex`. **LOC envelope revised iter-137 (per `mathlib-analogist-kaehler-tensorequiv-presheafpullback-iter137`): ~250–500 LOC body + ~110–210 LOC factorable helpers = ~360–710 LOC total** (widened from iter-133's 150–300 LOC by ~200 LOC). The revision reflects (a) Mathlib's `PresheafOfModules.pullback` opacity on `.obj`/`.map` (defined as `(pushforward φ).leftAdjoint`; needs an unfolding helper ~30–60 LOC), (b) the missing `Algebra.IsPushout`-from-affine-product helper ~80–150 LOC, (c) the **universal-property-at-presheaf-level route** (NOT chart-affine-cover-and-glue) imposed by `PresheafOfModules.isoMk`'s all-opens naturality requirement (`relativeDifferentialsPresheaf` is a presheaf, not a sheaf). **Recommended stall threshold for follow-up analogist call: body alone > 400 LOC without close-in-sight**. Persistent file: `analogies/kaehler-tensorequiv-presheafpullback.md`. **Trigger (a')/(c) interaction**: cumulative (i.b)-side build entering iter-137 is ~316 LOC (iter-134→iter-136 delta); the revised Step 2 envelope's midpoint (~530 LOC) brings cumulative to ~846 LOC, **crossing the 600 LOC trigger arm**. The trigger fires by definition once the revised envelope's midpoint lands; this is no longer a watchpoint but an expected condition. **Iter-137 plan-agent resolution (rebuttal-with-scope-note)**: the iter-134 LOC trigger was calibrated against the iter-133 150–300 LOC envelope (which assumed a chart-affine-cover-and-glue route that Mathlib's `PresheafOfModules.pullback` opacity rules out). Under the iter-137 analogist's revised universal-property route, the 600 LOC arm of trigger (a') is **mechanically satisfied by the envelope itself** — firing on the LOC arm alone would be a sunk-cost-shaped over-revert. Trigger (a') retains its non-LOC components: it still fires if (a'.1) pointwise-translation through `k̄`-rational points is required, OR (a'.2) the prover pivots to value-level-stalk RHS phrasing. **The 600 LOC arm of trigger (a')/(c) is renormalised iter-137 to "cumulative (i.b)-side build > 1000 LOC without converging"** (~316 LOC iter-136 baseline + ~710 LOC upper envelope + ~30% slack = ~1000 LOC). Iter-137 prover lane firing at the revised envelope does NOT fire the LOC arm. Future iter-138+ on Main composition (~20–40 LOC) lands well under the renormalised cap. **`strategy-critic-iter137` re-verification of this renormalisation expected iter-138.**

- **Gap (categorical shear iso `σ = ⟨pr₁, μ⟩ : G ⊗ G ≅ G ⊗ G` in `Over (Spec k)`, PHANTOM)**: subsumed by **milestone M2.body-pile piece (i.b)** as a NEEDS_MATHLIB_GAP_FILL sub-piece (~30–60 LOC; identified iter-133). Construction template: `CategoryTheory.GrpObj.mulRight` (`Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281`); inverse construction patterned on `GrpObj.isPullback` (Grp_.lean:293-323). Clean GAP_FILL, not divergence from any idiom.
- **Gap (scheme-level `df=0 ⇒ factors-through-Spec-k`, `Scheme.Over.ext_of_diff_zero` PHANTOM)**: subsumed by milestone M2.body-pile piece (ii). **`Differential.ContainConstants` alignment — RESOLVED iter-138** (per `mathlib-analogist-containConstants-iter138`; consult front-loaded from iter-139/140 per `strategy-critic-iter138` Alt #4). **Verdict: PIN path (b)** direct `KaehlerDifferential.D` route — reject path (a) `Differential.ContainConstants` typeclass install (Mathlib's `Differential R` instances exist only for differential **field** extensions in the Liouville tradition; no instance for any non-field commutative algebra; installing on chart algebras requires non-canonical `Classical.choose` of a cotangent generator and yields a STRICTLY WEAKER fact). **LOC envelope (path b)**: ~300–600 LOC total = algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` ~200–350 LOC + integrally-closed-constants helper ~50–100 LOC + scheme-level lift via `Scheme.Over.ext_of_eqOnOpen` ~100–150 LOC. **Scaffold-shape recommendation**: `ext_of_*` paired-morphism pattern with explicit `[CharZero k]` gate (char-p handled by piece (iii) composition; the path (b) `df=0 ⇒ constant` argument is char-0-dependent). **Iter-138/139 blueprint update obligation**: `RigidityKbar.tex:68` piece (ii) prose should drop the loose "aligns with `Differential.ContainConstants`" framing before iter-141+ scaffolding starts (deferred to iter-139 blueprint-writer dispatch). Persistent file: `analogies/differential-containConstants-alignment.md`.
- **Gap (scheme-level absolute Frobenius, `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM)**: subsumed by milestone M2.body-pile piece (iii). **PROVISIONAL Honest size (per `strategy-critic-iter128`): 800–1500 LOC over 4–7 iter** (revised from iter-127's 300–600 LOC / 2 iter). The project must build the scheme-level Frobenius from the ring-side `Mathlib.Algebra.CharP.Frobenius` — Mathlib `b80f227` has NO scheme-level Frobenius at all (`lean_local_search` "Frobenius" returns only `NumberTheory.FrobeniusNumber.lean`, unrelated). Stacks Tag 0CC4 is the canonical reference for the scheme-level construction. **Upstream-PR shape (named iter-138 per `strategy-critic-iter138` Alternative #1; deferred decision resolved iter-138 by `mathlib-analogist-p1-hedge-iter138` NOT-VIABLE verdict)**: `AlgebraicGeometry.Scheme.absoluteFrobenius` is canonical Mathlib infrastructure (Stacks Tag 0CC4; consumed by every char-p scheme argument), structurally analogous to the M1.d `kaehler_quotient_localization_iso` off-loop PR-extraction precedent. The project's in-tree build is the working version; **once piece (iii) lands substantively in-tree, an off-loop PR-extraction lane will be opened** (mirror in-tree → upstream-shaped Mathlib PR draft, same precedent infrastructure as M1.d). **Iter-138 decision**: since the ℙ¹-hedge analogist returned NOT-VIABLE (no Mathlib compression of piece (iii) to ring-side `k[t]` instances; hedge cost STRICTLY MORE expensive than bundled pile), piece (iii) WILL need to be built in-tree at 800–1500 LOC. The PR lane therefore opens iter-144+ alongside the in-tree build (no further deferral); the M1.d off-loop infrastructure carries forward. **Iter-139 honest acknowledgement** (per `strategy-critic-iter139` Must-fix #5 / sunk-cost flag #3): the in-tree-build commitment is **switching-cost + zero-sorry-end-state-commitment-driven**, NOT a "in-tree is cheaper" decision. The `mathlib-analogist-p1-hedge-iter138` analogist's explicit recommendation that **named-gap sorry IS the cheaper escape hatch** (~0 LOC + 0 iter; documents the gap in blueprint, downstream consumers carry one residual named gap) is **recorded as an active alternative**, not a stall fallback. Gating: the iter-144+ piece (iii) build is gated on "iter-141 piece (i.c) closure + iter-143 piece (ii) closure both substantive"; if either of those returns PARTIAL across 2+ iters, the iter-144+ plan agent MUST re-open this decision before committing the 800–1500 LOC in-tree build. **Iter-132 PROVISIONAL flag** (per `strategy-critic-iter132` M3 must-fix + SC3 sunk-cost flag): the 800–1500 LOC commitment is provisional pending an iter-140+ scheduled mathlib-analogist consult on the **no-Frobenius / higher-Kähler-vanishing alternative** for piece (iii). The alternative: in characteristic `p`, the obstruction handled by Frobenius iteration is that `df = 0` doesn't directly imply `f` factors through `Spec k` when `f` is given by `p`-th powers. The bypass alternative appeals to the *vanishing* of the higher Kähler differentials `Ω_{C/k}^{⊗p^n}` on a smooth proper genus-0 curve (which reduces to `H¹(ℙ¹, O) = 0` on charts), giving a non-iterative cotangent-vanishing argument. If the iter-140+ analogist verifies the higher-Kähler vanishing pieces are present in Mathlib `b80f227` with materially lower LOC than the 800–1500 LOC scheme-level absolute-Frobenius build, piece (iii) pivots; otherwise the scheme-level absolute-Frobenius build proceeds per the current commitment. **Schedule (iter-133 revised)**: advance from iter-140+ to **iter-135–138** per `strategy-critic-iter133` minor recommendation, so the verdict feeds piece (i.c) iter-137+ scaffolding AND piece (ii) iter-141+ scaffolding (the iter-140+ schedule missed the dependency that the higher-Kähler-vanishing argument might also compose differently with piece (i.c) `omega_free` / `omega_rank_eq_dim` and the piece (ii) ring-side `Differential.ContainConstants` chain). Co-scheduled with the ℙ¹-specific rigidity hedge analogist (line 517 below) — both fire iter-135–138 in adjacent iters; combined they would compress piece (iii)'s 800–1500 LOC commitment substantially if either yields a viable alternative.
- **Gap (Serre duality on a smooth proper curve)**: standalone gap (3000–8000 LOC per `analogies/serre-duality.md` iter-110 verdict). **NOT NEEDED under iter-127 over-k commitment**; named gap preserved for potential future use (M2.d RR fallback, or M4 if downstream consumers materialize).
- **Gap (scheme-level cotangent sheaf)**: bundled into piece (i)'s 800–1500 LOC estimate; standalone-unbundling alternative **deferred to iter-129+ if piece (i) bridge cost exceeds budget** (per `strategy-critic-iter127` alternative).

All in-scope gaps are listed; none are project-external. The loop's job is to execute the roadmap, one sub-step per iter, recording PARTIAL progress in `PROGRESS.md` and the iter sidecar as each sub-step advances.

## Sequencing (current snapshot, iter-127)

The current loop position: **iter-127 M2.b scaffold + over-k strategic commitment**. The iter-127 over-k analogist returned OK_OVER_K on the shared pile's three active pieces; the strategy adopts the over-k path, dropping M2.c + M2.c.aux. **iter-128 fires the META-PATTERN TRIPWIRE prover lane** on a piece-(i) sub-lemma (staged this iter via blueprint-writer dispatches).

**Iter-127 deliverable (this iter, plan-phase-only):**
- `refactor-m2b-scaffold-iter127` lands the `genusZeroWitness` named declaration in `Jacobian.lean` with a single `sorry` body (per directive Option A; +1 project sorry, 2 → 3).
- `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` returns the OK_OVER_K verdict (`analogies/cotangent-vanishing-pile-over-k.md`).
- 3 mandatory critics dispatch + return: `strategy-critic-iter127`, `blueprint-reviewer-iter127`, `progress-critic-iter127`.
- Blueprint-writer dispatches stage iter-128 prover target: piece-(i) sub-lemma decomposition added to `RigidityKbar.tex`; `genusZeroWitness` definition block added to `Jacobian.tex`.

**Iter-128 deliverable (next iter):** scaffold the first piece-(i) sub-lemma named declaration (TBD by iter-127 blueprint-writer; likely candidate: `AlgebraicGeometry.GrpObj.lieAlgebra` or `Scheme.absoluteFrobenius` shape) and dispatch a prover lane on it. **This iter is the META-PATTERN TRIPWIRE checkpoint** per the iter-126 progress-critic: iter-128 MUST dispatch a prover or the meta-pattern flips to CHURNING.

**Multi-year wait window (revised iter-141 per `strategy-critic-iter141` must-fix #5; the iter-127 framing "shaved 7–13 iter / 500–900 LOC" is superseded by the iter-128-revised "2–6 iter / 0–500 LOC" net savings — see Sequencing § "Pile (i)+(ii)+(iii) total" and `strategy-critic-iter140` material concern #2 multi-year wall-clock correction).** Parallel productive lanes (with HONEST iter-ranges):

| Iter range | Lane | Output | Per-row iter cost |
|---|---|---|---|
| 125 | Rigidity refactor (DONE) | `Scheme.Over.ext_of_eqOnOpen` lands; blueprint cross-refs updated | 1 iter |
| 126 | M2.a scaffold + over-`k̄` analogist (DONE) | (a) `rigidity_over_kbar` named declaration scaffolded with a `sorry` body; (b) mathlib-analogist consult on the over-`k̄` shared pile pulled forward from iter-130. | 1 iter |
| 127 | M2.b scaffold + over-k analogist + strategic refactor (THIS ITER, DONE) | (a) `genusZeroWitness` defined as a `JacobianWitness C` builder with single `sorry` body (`Jacobian.lean:174–178`); (b) over-k mathlib-analogist consult returned OK_OVER_K on all three pile pieces, **adopting the over-k path**; (c) STRATEGY.md revised to drop M2.c + M2.c.aux; (d) blueprint-writer dispatches for piece (i) sub-decomposition + Jacobian.tex genusZeroWitness block to stage iter-128 prover lane per iter-126 META-PATTERN TRIPWIRE. | 1 iter |
| 128 (THIS ITER) | Piece (i.a) scaffold + first prover lane (META-PATTERN TRIPWIRE fires; iter-128 RE-SCOPED per `strategy-critic-iter128` CHALLENGE) | **Refactor**: scaffold ONLY `AlgebraicGeometry.GrpObj.lieAlgebra` (the *definition* of the cotangent at the identity as a `k`-module; NO rank lemma this iter) in new file `AlgebraicJacobian/Cotangent/GrpObj.lean`, with `sorry` body. **Prover dispatch** on the same declaration immediately after the refactor lands. The rank lemma `lieAlgebra_finrank_eq_dim` is deferred to iter-129+ for two reasons: (i) the rank's RHS Lean encoding (`n` parameterised by `[SmoothOfRelativeDimension n G.hom]` instance) needs blueprint pinning iter-129 before being prover-ready; (ii) bundling definition + rank into one iter-128 prover task is borderline-too-ambitious per `progress-critic-iter128`. **Rename `rigidity_over_kbar` → `rigidity_over_k`** is deferred to iter-129 as a low-priority cleanup refactor; iter-128 stays focused on the prover lane. | 1 iter (refactor + prover dispatch + iter-129 fallback rule codified) |
| 128 → 132 (5 iter; **DONE iter-132**; empirical cost **~600 LOC build-and-correct across 3 body reshapes; final tree state 284 LOC**) | **Piece (i.a) definition + rank lemma — DONE** — `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (iter-128 → iter-131 body refactor cycles, 3 reshapes: iter-128 zero-collapse defect → iter-130 chart-base-change body but opaque-witness defect → iter-131 pure-term `Classical.choose`-chain refactor that finally proved tractable for the iter-132 rank-lemma close) + `cotangentSpaceAtIdentity_eq_extendScalars` (iter-131 strong acceptance lemma) + `cotangentSpaceAtIdentity_finrank_eq` (iter-132 rank lemma close, kernel-only, 0 sorry). **Total cost iter-128→iter-132 across 3 body reshapes: ~600 LOC of build-and-correct work (iter-134 honest-framing per `strategy-critic-iter134` CHALLENGE 3); final tree state `AlgebraicJacobian/Cotangent/GrpObj.lean` 284 LOC, all three declarations land, no sorry.** The ~300 LOC midpoint reads the final-tree-state size; the corrective overhead (~600 LOC build-and-correct) is the visible-to-future-reader signal that "definition + rank lemma" was harder than the iter-127 estimate (1 iter, no corrective cycles assumed). **Piece (i.a) closes the META-PATTERN TRIPWIRE watch** (iter-128 → iter-131); the no-4th-body-reshape commitment remains binding as a guardrail. | 250–500 LOC (final-tree midpoint ~300; build-and-correct overhead ~600). | 5 iter (DONE iter-132). |
| **iter-133 (THIS ITER)** | **Piece (i.b) blueprint hardening + design analogist** — `strategy-critic-iter131` Q3 carry-over fired: iter-133 mathlib-analogist (`mulright-globalises-cotangent`) returned PROCEED with the iter-131 (B)-body composition, recommended sheaf-level RHS phrasing (`Ω_{G/k} ≅ pr_1^* (η_G^* Ω_{G/k})` at presheaf level), refuted the iter-130 strategy-critic Q2 worry that piece (i.b) needs an inline (B)→(A) stalk-cotangent bridge (it doesn't; chart-localisation identification ~100–200 LOC pushed into piece (i.c) instead). Iter-133 blueprint-reviewer DEFER on piece (i.b) prover dispatch (blueprint inadequate for prover); iter-133 blueprint-writer hardens `lem:GrpObj_mulRight_globalises` per the 4 must-fix items (signature stub, name-vs-construction clarification, base-change-of-differentials Mathlib lemma name, optional section-restriction sub-lemma). **Trigger (a') refinement (iter-133)**: fires only if the iter-134+ prover lane chooses value-level-stalk RHS phrasing; with the recommended sheaf-level RHS, trigger (a') does NOT fire. | Blueprint hardening this iter (~50–100 LOC of `.tex`); no Lean work this iter. | 1 iter. |
| 134+ (revised iter-133 per analogist + blueprint-writer; LOC envelope re-revised iter-137 per `mathlib-analogist-kaehler-tensorequiv-presheafpullback-iter137`) | **Piece (i.b) prover lane** — `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` (shear-iso globalisation; sheaf-level RHS per the iter-133 mathlib-analogist verdict). The closure path needs (per `analogies/mulright-globalises-cotangent.md` + `analogies/kaehler-tensorequiv-presheafpullback.md`): (a) **Step 1** shear iso `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` (~30–60 LOC NEEDS_MATHLIB_GAP_FILL; template `CategoryTheory.GrpObj.mulRight`; **DONE iter-134** as `shearMulRight`); (b) **Step 2** base-change-of-differentials natural iso `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` (revised iter-137 envelope: ~250–500 LOC body + ~110–210 LOC factorable helpers = ~360–710 LOC total NEEDS_MATHLIB_GAP_FILL; universal-property-at-presheaf-level route via `PresheafOfModules.isoMk`, NOT chart-affine-cover-and-glue; **iter-137 prover target**); (c) **Step 3** section-restriction along `⟨id_G, η_G⟩` (~27 LOC, **DONE iter-136** as `relativeDifferentialsPresheaf_restrict_along_identity_section`); (d) **Main Compose** (~20–40 LOC, iter-138+ target). **Trigger (a') LOC arm renormalised iter-137 from 600 LOC to 1000 LOC cumulative** (the iter-134 cap was calibrated against the iter-133 150–300 LOC envelope which assumed a chart-affine-cover route Mathlib's `PresheafOfModules.pullback` opacity rules out; under the iter-137 analogist's revised universal-property route, the 600 LOC arm would fire mechanically on the envelope itself — sunk-cost-shaped over-revert). **`Classical.choose`-chain composability**: VERIFIED iter-133 — the iter-131 body composes with the shear iso via the chart-localisation identification that's pushed into piece (i.c.1). | **Revised iter-137 (Step 2 dominant): ~410–810 LOC total** (Step 1 ~50 + Step 2 ~360–710 + Step 3 ~27 + Main ~20–40). | 3–5 iter (revised iter-137 from iter-133's 2–4 iter; iter-134→iter-138 expected; iter-137 Step 2 single iter is the envelope-determining lane). |
| 137+ (revised iter-131; decomposed iter-137 per `strategy-critic-iter137` CHALLENGE) | **Piece (i.c.1) chart-localisation identification** — `relativeDifferentialsPresheaf` pulled back along `η_G` ≅ chart-base-changed `cotangentSpaceAtIdentity G`. **Pushed in from piece (i.b)** by the iter-133 mathlib-analogist's sheaf-level-RHS recommendation; structurally distinct from `omega_free` (consumes the chart-`Classical.choose`-chain that defines `cotangentSpaceAtIdentity G`'s body, plus an `extendScalars`-vs-`TensorProduct` shape massage on top of `relativeDifferentialsPresheaf_obj_kaehler`). Independent prover-laneable artefact. | **100–200 LOC** (iter-133 analogist envelope; the artefact pushed in from (i.b)). | 1 iter. |
| 137+ (iter-137 decomposition; `strategy-critic-iter137` CHALLENGE) | **Piece (i.c.2) `omega_free`** — freeness conclusion of `Ω_{G/k}` as `O_G`-module. Consumes `mulRight_globalises_cotangent` (piece (i.b) Main, iter-138+) **and** the (i.c.1) chart-localisation identification. Mathematical content: a structure-map pullback of a free `k`-module is a free `O_G`-module. Small assembly lemma. | **50–150 LOC**. | 1 iter (can co-fire with (i.c.3)). |
| 137+ (iter-137 decomposition; `strategy-critic-iter137` CHALLENGE) | **Piece (i.c.3) `omega_rank_eq_dim`** — rank pinning `(Ω_{G/k}).rank = n` where `n` is the relative dim from `[SmoothOfRelativeDimension n G.hom]`. Consumes (i.c.2) `omega_free` + `cotangentSpaceAtIdentity_finrank_eq` (closed iter-132). Small assembly lemma. | **50–150 LOC**. | 1 iter (can co-fire with (i.c.2)). |
| 139 or 140 (NEW iter-136 per `strategy-critic-iter136` CHALLENGE 2) | **Piece (ii) `Differential.ContainConstants` alignment analogist** — pin the bridge from the scheme-level Kähler-form `df = 0` argument (with `d : Γ(C, V) → Ω_{Γ(C, V) / Γ(Spec k, U)}`) to Mathlib's `Differential.ContainConstants A B` (keyed on `Differential B`, a derivation `B → B`). Two paths under evaluation: (a) install a `Differential` typeclass instance on chart algebras via a splitting of the universal derivation `B → Ω_{B/A}`; (b) pivot piece-(ii) to route through `KaehlerDifferential` exactness lemmas directly (`KaehlerDifferential.exact_mapBaseChange_map` family + a kernel-of-derivation argument). Analogist verdict pins LOC/iter cost differential and pivot recommendation. **MUST dispatch before iter-141+ piece-(ii) scaffolding** — entering iter-141+ with "morally aligned" framing risks repeating the iter-134 placeholder-pattern mistake (under-specified Lean shape spawning low-quality prover work). | n/a — analogist consult, no Lean work. | 1 iter. |
| 141+ (revised iter-131; alignment pinned iter-139 or iter-140 per the new row above) | **Piece (ii)** — scheme-level `df=0 ⇒ factors-through-Spec-k` (`AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`; alignment to Mathlib's `Differential.ContainConstants` OR direct `KaehlerDifferential` exactness route pinned by the iter-139/140 analogist; k-agnostic per iter-127 over-k analogist). | 250–500 LOC. | 2–3 iter. |
| 144+ (revised iter-131) | **Piece (iii)** — char-`p` Frobenius iteration (committed Option A per iter-126 + iter-127 analogists; consumes `Mathlib.Algebra.CharP.Frobenius`; scheme-level lift uses **absolute** Frobenius `F_X`, intrinsic to `X` — no perfectness/alg-closure required). **Revised iter-128 honest LOC accounting** (per `strategy-critic-iter128`): the project must FIRST build `AlgebraicGeometry.Scheme.absoluteFrobenius` (or equivalent) — there is NO scheme-level Frobenius in Mathlib `b80f227` (`lean_local_search` confirms only ring-side `Mathlib.Algebra.CharP.Frobenius` + `NumberTheory.FrobeniusNumber`). Stacks Tag 0CC4 sketches the scheme-level construction. | 800–1500 LOC. | 4–7 iter. |
| **Piece (iv)** | **DEFERRED as named-gap** (Serre duality). Used only by M2.d genus-0 identification arm (NOT ACTIVE under iter-127 over-k commitment). The iter-128+ shared-pile build does NOT include it. | Serre duality 3000–8000 LOC per `analogies/serre-duality.md` iter-110 verdict. | n/a (deferred) |
| ~~M2.c assembly~~ | **DROPPED iter-127** per over-k analogist. | n/a | **eliminated**: −4–8 iter / −300–500 LOC. |
| ~~M2.c.aux `geomIrred.exists_kalg_pt`~~ | **DROPPED iter-127**. | n/a | **eliminated**: −3–5 iter / −200–400 LOC. |
| 151+ (revised iter-131) | M2.a body closure | Apply pieces (i)+(ii)+(iii) to close `rigidity_over_kbar` (or post-rename `rigidity_over_k`) body. | 1–2 iter / 50–150 LOC. |
| 153–156 (2–4 iter, revised iter-131) | M2.b body closure + terminal-object instance cluster on `Spec k` | Close `genusZeroWitness` body using `rigidity_over_k`; build the four-instance cluster on `Spec k` needed for the genus-0 `JacobianWitness` (`GrpObj`, `SmoothOfRelativeDimension 0`, `IsProper`, `GeometricallyIrreducible`); encode the `C(k) = ∅` vacuity branch via `Classical.byCases` + `IsEmpty.elim`. **Revised iter-130** per `strategy-critic-iter130` Q5 under-count: prior estimate "1 iter / 100–200 LOC" missed the terminal-object cluster (~200–500 LOC / 2–3 iter alone) + the vacuity-branch encoding (~20–50 LOC). Honest revision: **2–4 iter / 320–750 LOC**. | 2–4 iter / 320–750 LOC. |
| 157+ (revised iter-131) | M2 closure | Genus-stratified body restructure of `nonempty_jacobianWitness` (the `by_cases h : genus C = 0` decomposition), gated also on M3 scaffolding. | 2–4 iter. |

**Honest M2 closure estimate (revised iter-131 per `strategy-critic-iter131` Q5 1-iter slip): iter-153 to iter-173+** (pieces (i)+(ii)+(iii) total 1850–3600 LOC over 9–20 iter starting iter-128, plus the iter-131 1-iter slip from piece (i.a)'s empirically-revised 5-iter cost; M2.a body closure iter-151+; M2.b body closure + terminal-object cluster + vacuity-branch iter-153+ /+320–750 LOC; M2 closure iter-157+ gated on M3 scaffold). Iter-130 added explicit budget for the iter-130 body-swap (~100–200 LOC of refactor work, single iter); iter-131 adds explicit budget for the iter-131 body-shape refactor (~50–100 LOC of refactor + ~30 LOC for the strong acceptance lemma + ~20 LOC of docstring refresh = ~100–150 LOC of corrective work, single iter). **Saving vs prior over-`k̄` baseline (revised iter-131): ~2–5 iter / 0–500 LOC** (the dropped M2.c + M2.c.aux nets a smaller saving once piece (iii) honest-Frobenius LOC + Q5 under-counts + iter-131 1-iter slip are corrected; the over-k commitment remains net-positive but the case is narrower than the iter-127/iter-130 framings suggested). The iter-131 sequencing supersedes the iter-130 "iter-152 to iter-172+" estimate.

The 9–20 iter range for the pile breaks down as: piece (i) 5–11 iter (definition-only iter-128 + rank-lemma iter-129+ + (i.b) shear + (i.c) freeness),
piece (ii) 2–3 iter, piece (iii) **4–7 iter** (revised iter-128; scheme-level absolute Frobenius is missing from Mathlib `b80f227` and the project must build it on the way) — in sequence; (i) must close
before (ii) and (iii) can build.

**Direct over-k rigidity — COMMITTED iter-127** (per `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` OK_OVER_K verdict). The cotangent-triviality argument is intrinsic (the shear iso `(a, b) ↦ (a, a·b)` is a scheme map over any base); pieces (i)+(ii)+(iii) build directly over any base field `k`; M2.c (Galois descent) and M2.c.aux (`geomIrred.exists_kalg_pt`) are eliminated. The iter-126 scaffold's Lean signature is already k-agnostic. **Risks** (per the analogist's risk register; revert option preserved):

- Piece (i) **must use the functorial shear-iso globalisation**, not pointwise translation. Pointwise translation would require `k̄`-rational points to translate the cotangent at the identity to a frame on the whole group; the shear iso avoids this.
- Piece (iii) **must use absolute Frobenius `F_X`** (intrinsic to `X`, independent of base), not relative Frobenius `F_{Y/k}` (which over non-perfect `k` would require `[PerfectField]`).
- **Revert option (with concrete triggers per `strategy-critic-iter128` sunk-cost flag; trigger (a) RETARGETED iter-129; trigger (a') REFINED iter-133)**: if **any one** of (a') **iter-134+ prover lane on piece (i.b) `mulRight_globalises_cotangent` returns INCOMPLETE on a *functorial* shear-iso route with the recommended **sheaf-level RHS** phrasing (per iter-133 mathlib-analogist) and only closes when either (a'.1) pointwise-translation through `k̄`-rational points is allowed OR (a'.2) the prover lane pivots to **value-level-stalk RHS** phrasing requiring an inline (B)→(A) bridge construction (~300–600 LOC); (b) piece (iii) build at iter-143+ exceeds **1200 LOC** while less than 50% complete; (c) iter-129 mathlib-analogist on the `lieAlgebra` rank-bridge reports that the presheaf-evaluate-then-extend-scalars route demands materially more sheafification / sheaf-coincidence infrastructure than the over-`k̄` cotangent-stalk route, **revert to the over-`k̄` baseline + reintroduce M2.c**. Cost of revert: ~1 iter of strategic backtrack + restoration of M2.c rows. **Iter-133 status**: trigger (a') is now checkable at iter-134+ piece (i.b) prover-lane close (the iter-133 blueprint hardening + analogist verdict prepare the lane); trigger (b) checkable iter-143+ piece (iii); trigger (c) was checked iter-129 and returned NOT-FIRED. **Watchpoint per `strategy-critic-iter133` + `strategy-critic-iter134` CHALLENGE 1 (LOC trigger added iter-134; renormalised iter-137)**: if iter-134+ piece (i.b) shows **> 2 iter slip beyond the (revised iter-137) 3–5 iter envelope OR > 1000 LOC of cumulative (i.b)-side build without converging**, trigger (a')/(c) must fire — do not silently absorb the slip on either axis. The iter-134 LOC cap of 600 LOC was calibrated against the iter-133 150–300 LOC envelope; the iter-137 mathlib-analogist's revised universal-property route envelope (~360–710 LOC for Step 2 alone) mechanically saturates the 600 LOC cap on the envelope itself. **Renormalisation to 1000 LOC (~316 LOC iter-136 baseline + ~710 LOC upper envelope + ~30% slack)** keeps the LOC arm a genuine watchpoint rather than a mechanical fire — firing on the iter-134-calibrated 600 LOC cap under the iter-137-revised envelope would be sunk-cost-shaped over-revert. The LOC arm still protects against the failure mode where a piece (i.b) lane ships >1000 cumulative LOC across iter-134→iter-138 while still failing to close the sheaf-level RHS recipe; LOC overrun is an independently sufficient signal of an under-scoped envelope IF the build path itself stalls. Iter-137 prover lane on Step 2 firing at the revised envelope does NOT fire the LOC arm.

- **Over-k re-defense on revised numbers (per `strategy-critic-iter129` sunk-cost flag; iter-130 ground (i) STRUCK per `strategy-critic-iter130` Q1 CHALLENGE).** The iter-128-revised net savings of over-k vs over-`k̄` collapsed from 7–13 iter / 500–900 LOC to 2–6 iter / 0–500 LOC — a lower bound of zero. The over-k commitment is no longer defended by quantitative LOC/iter savings alone; the iter-129 affirmative defense rested on three grounds, of which iter-130 strikes the first as empty evidence:
  - ~~(i) iter-128 prover lane closed `lieAlgebra` body kernel-clean on the over-k path~~ — **STRUCK iter-130** per `strategy-critic-iter130` Q1. The closed body provably computes the zero `k`-module for the consumer class (per `analogies/lieAlgebra-rank-bridge.md` Decision 1), so a kernel-clean closure is evidence only of Lean type-checking, not of over-k tractability for the rank-`n` target. Treating it as positive evidence is sunk-cost; the iter-128 deliverable is being replaced this iter (iter-130 body swap to Replacement (B)) and cannot simultaneously count as validation.
  - (ii) the over-k blueprint is cleaner (one chapter `RigidityKbar.tex` over `[Field k]` instead of two chapters with an intermediate `[Field k̄]` and a Galois-descent reconciliation). **Retained.**
  - (iii) trigger (c) above is wired — if the analogist reports the presheaf-vs-sheaf bridge cost is materially worse than the over-`k̄` stalk-at-identity route, the revert is automatic. **Retained; trigger (c) FIRED iter-129 and returned PROCEED on the over-k path** (Replacement (B) chosen as the body presentation; standalone-sheaf detour deferred).

  - (iv) **REINSTATED iter-133** as **iter-132 piece (i.a) tractability evidence** (NOT iter-131; NOT whole-pile / whole-over-k-path validation; per `strategy-critic-iter133` must-fix scope-narrowing). The iter-132 prover lane closed `cotangentSpaceAtIdentity_finrank_eq` at `AlgebraicJacobian/Cotangent/GrpObj.lean:244` with no `sorry`, kernel-only axioms `{propext, Classical.choice, Quot.sound}`, references `Module.finrank_baseChange` AND `Module.finrank_eq_of_rank_eq` — the iter-132 reinstatement criterion (line 498 prior) is objectively satisfied. **Scope guardrail (iter-133)**: this is **piece (i.a) tractability evidence only**. Pieces (i.b)/(i.c)/(ii)/(iii) tractability over k remains empirically untested; future iters MUST NOT conflate piece (i.a) success with whole-path validation. The empirical cost of piece (i.a) is 5 iter / ~300 LOC (within the iter-131 revised 250–500 LOC range, just below the midpoint). **Re-open criterion (retained)**: if any subsequent over-k pile piece slips by > 50% above its iter-131-revised estimate without closing (e.g. piece (i.b) blows past 750 LOC and 6 iter without converging), the over-k vs over-`k̄` decision is formally re-opened with mid-iter strategy-critic re-dispatch on a route-pivot question.

  **Re-framed iter-136** (per `strategy-critic-iter136` CHALLENGE 1 on the qualitative defense framing): the over-k commitment is now honestly defended on two grounds, with (iii) demoted from a "defense ground" to a "risk mitigation" classification:

  - **(ii) Blueprint cleanliness (load-bearing, switching-cost-flavored).** One chapter `RigidityKbar.tex` over `[Field k]` instead of two chapters with an intermediate `[Field k̄]` and a Galois-descent reconciliation. **Honestly named as switching cost**: this ground reflects past investment in `RigidityKbar.tex` and the iter-128 → iter-132 build over `[Field k]`; it is real, but not independent positive evidence the over-k route is better than over-`k̄` *in the abstract*. The switching cost of reverting to over-`k̄` (re-doing the chapter + restoring M2.c rows) is concrete (~1 iter; see (iii) cost-of-revert).
  - **(iv) Piece (i.a) tractability (scope-narrow, route-validation only).** The iter-132 closure of `cotangentSpaceAtIdentity_finrank_eq` content-bearing references `Module.finrank_baseChange` AND `Module.finrank_eq_of_rank_eq` — empirical evidence that the over-k construction is Lean-tractable for piece (i.a). **Scope guardrail**: this is *route-validation* evidence (the over-k route works for piece (i.a)), NOT *route-comparison* evidence (over-k vs over-`k̄`); the same proof would have worked over `k̄`. Pieces (i.b)/(i.c)/(ii)/(iii) tractability over k remains empirically untested; future iters MUST NOT conflate piece (i.a) success with whole-path validation.
  - ~~(iii) Active revert option~~ — **DEMOTED iter-136 from "defense ground" to "risk mitigation" classification** per `strategy-critic-iter136` CHALLENGE 1: "we have an escape hatch" is *risk mitigation*, not *positive defense*. The revert wiring (trigger (a') at iter-134+ piece (i.b); trigger (b) at iter-143+ piece (iii); cost of revert ~1 iter + restoration of M2.c rows) is retained as a guardrail against the route being wrong; it does NOT argue the over-k route IS right. Future iters must not cite (iii) as positive evidence; it is bounded-downside framing only.

  Future iters must NOT cite the iter-128 close (per iter-130 strike) or the iter-131 close (per iter-132 strike) as evidence of tractability; only iter-132 (and later) **closes that reference content-bearing Mathlib chains for piece (i.a) — and the analogous content-bearing chains for downstream pieces** — are admissible evidence.

  **Net iter-136 framing**: the over-k commitment carries on ground (ii) blueprint cleanliness honestly named as switching cost + ground (iv) piece (i.a) tractability honestly scoped to route-validation; ground (iii) revert wiring is retained operationally but no longer load-bearing. Quantitative case is lower-bound zero; the decision is operationally correct but does not have a strong "the over-k route IS better" defense. If the next route-pivot trigger fires (a' / b / c), revert without further deliberation.

  **Iter-138 reframing to "operationally defaulted, bounded revert cost preserved"** (per `strategy-critic-iter138` Must-fix on over-k commitment language). Given that (i) was struck (iter-130), (iii) was demoted to risk-mitigation (iter-136), the quantitative case lower-bound is zero (iter-128), and the retained grounds (ii) + (iv) are scope-honest (switching cost + single-piece route-validation), the strategy adopts the iter-137 REBUTTED-WITH-SCOPE-NOTE alternative #3 substantively (not just at the language level): the over-k path is the **operational default** — not because we have a strong positive case for it, but because we have been building there, the switching cost back to over-`k̄` is concrete (~1 iter), and the revert wiring is in place. Language elsewhere in this strategy that still calls (ii)+(iv) "defense grounds" should be read as "operational-default grounds": the strategy does NOT claim over-k is sounder or cheaper than over-`k̄` in the abstract; it claims that **given the project's current state**, defaulting to over-k with explicit revert triggers is the lowest-friction path. **Conditional ground extension (iter-138)**: if iter-138 prover lane closes Step 2 substantively, ground (iv) extends from "piece (i.a) only" to "piece (i.a)+(i.b)" — both substantive over-k closures with content-bearing Mathlib chains, two pieces of empirical tractability evidence. If iter-138 returns PARTIAL again, ground (iv) stays scope-narrow and the cumulative weight of "single piece of empirical tractability evidence after 11 iter of build" warrants explicit re-discussion in iter-139 plan phase (not auto-revert, but auto-flag).

  **Iter-139 §519 auto-flag execution** (per `strategy-critic-iter139` Must-fix #2). Iter-138 returned PARTIAL on piece (i.b) Step 2 with substantive structural body cut (Route (b) skeleton landed end-to-end; d_add + d_mul of the pointwise derivation closed honestly; d_app + d_map + IsIso sub-sorries remain). The §519 auto-flag has fired. **Iter-139 plan-agent re-discussion** concluded **CONTINUE with over-k**, with explicit acknowledgements: (1) the empirical tractability evidence is now "piece (i.a) + piece (i.b) Step 3 substantively closed" (iter-132 + iter-136), slightly broader than iter-138's "single piece" framing but still scope-narrow against the 5-piece pile; (2) Step 2's PARTIAL trajectory is the **expected** behaviour under the iter-137 `kaehler-tensorequiv-presheafpullback-iter137` revised envelope (~360–710 LOC for Step 2 alone), not a stall — two PARTIAL iters on a 360–710 LOC closure IS the iter-138 progress-critic's "first substantive attempt iter" pattern; (3) revert cost remains ~1 iter; revert wiring (triggers (a'), (b), (c)) is preserved. **Named criterion for the next re-discussion (iter-140+ checkpoint, binding)**: if iter-140 closes ≥2 of 3 piece (i.b) Step 2 sub-sorries (d_app + d_map at minimum) AND projected cumulative (i.b)-side build stays below 1000 LOC, ground (iv) extends to "(i.a)+(i.b)-substantive". If iter-140 closes 0 or 1 sub-sorries (third consecutive PARTIAL), iter-141 plan agent fires CHURNING-trigger per `progress-critic-iter139` watch criterion AND re-opens the over-k vs over-`k̄` decision with mid-iter strategy-critic re-dispatch on the route-pivot question (NOT silent absorption). Full re-discussion at `iter/iter-139/plan.md § "§519 over-k auto-flag re-discussion"`.

  **Iter-141 decoupling correction (per `strategy-critic-iter141` must-fix #4).** The iter-139 pre-commitment wired CHURNING-trigger to "re-open the over-k vs over-`k̄` route-pivot question" as the strategy-critic mid-iter question. Iter-141 executed the pre-commitment; `strategy-critic-iter141` returned **REJECT THE PIVOT** with reasoning: piece (i.b) is **base-independent** (the shear iso + base-change-of-differentials are intrinsic to the group-scheme construction, base-independent), so switching over-k → over-`k̄` would change nothing about the bottleneck. **Lesson for future pre-commitments**: a CHURNING-trigger should pull in a strategy-critic on the **immediate prover-lane shape** (the (A)/(B)/(C)/(D) decision, see iter-141 plan), with route-pivot as one of several possible responses, not the wired-in question. **Discipline rule (iter-141 forward)**: a CHURNING-trigger pre-commitment must name the **diagnostic question** ("what is the right corrective for this CHURNING route?"), NOT a specific pre-committed answer. Iter-141 onward: route-pivot remains an available corrective when the bottleneck IS base-dependent or pile-substituting, but CHURNING-triggers stop wiring it as the default.

- **`Classical.choose`-chain body shape under Replacement (B) — RESOLVED iter-131** (per `mathlib-analogist-cotangent-body-shape-iter131`). The iter-130 prover lane shipped a `Classical.choice (Nonempty.intro X)` body wrapping the explicit chart-base-changed Kähler module `X`; this discarded structural access for downstream consumers. The iter-131 mathlib-analogist verified that the proposed `Classical.choose`-chain refactor (pure-term `noncomputable def` with `let`-bindings on `Classical.choose` / `.choose_spec` of `smooth_locally_free_omega`) restores structural exposure: after `unfold cotangentSpaceAtIdentity` and delta-reduction of `let`-bindings, the outer head symbol is `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])`. Mathlib precedent: `Polynomial.SplittingFieldAux` (`Mathlib.FieldTheory.SplittingField.Construction:126-138`). The iter-131 refactor lane landed this body shape with the strong acceptance lemma `cotangentSpaceAtIdentity_eq_extendScalars` closing by `refine … rfl⟩` — the strategy-critic-iter131 testable-deliverable requirement is met empirically. Persistent file: `analogies/cotangent-body-shape.md`.

- **Replacement (B′) chart-level `m_V / m_V²` — SCOPED AND REJECTED iter-131** (per `mathlib-analogist-cotangent-body-shape-iter131` Decision 3). Strategy-critic-iter131 surfaced (B′) as a "chart-level intermediate between (A) and (B)" candidate. The iter-131 mathlib-analogist verified (via `lean_loogle` + grep) that (B′) shares the same load-bearing [gap] with (A): the "standard-smooth-over-field-at-prime ⇒ IsRegularLocalRing of dim n" bridge (500–1000 LOC) is required under both (A) and (B′); (B′) only saves ~100–200 LOC of the geometric-stalk identification step. (B′) is **not** intermediate between (A) and (B); it is closer to (A) on cost. Decision: stay on (B) with the `Classical.choose`-chain refactor; defer (B′)/(A) until trigger (a') fires at iter-133+ piece (i.b).

- **Fibre-free piece (i) reformulation — EVALUATED iter-133, DECISION: STAY ON (B)** (per `strategy-critic-iter132` M4 must-fix elevation + `strategy-critic-iter133` minor scoring-shape upgrade from 1-axis to 4-axis scorecard). The fibre-free option (prove `Ω_{G/k}` globally free of rank `n` directly via the shear iso without ever naming a "cotangent at identity" object) was scheduled iter-132 for unconditional evaluation at iter-132 close. **Iter-133 4-axis evaluation result** (strategy-critic-iter133 flagged the iter-132 1-axis "`>20%` LOC differential" rule as too narrow; the project records the evaluation on 4 axes per their recommendation):

  | Axis | Replacement (B) under iter-131 `Classical.choose`-chain | Fibre-free (`Ω_{G/k}` globally free directly) |
  |---|---|---|
  | (1) LOC for pieces (i.b)+(i.c) | 210–440 LOC for (i.b) [iter-133 mathlib-analogist verdict, sheaf-level RHS]; 100–300 LOC for (i.c) including the chart-localisation identification (~100–200 LOC) pushed in from (i.b); **bundled 310–740 LOC** | ~400–800 LOC bundled (iter-132 STRATEGY.md estimate) |
  | (2) Canonicity | Non-canonical (chart `V` chosen by `Classical.choose`; the body has fixed structural shape but the *value* depends on the unspecified chart) | Avoids the named "cotangent at identity" object entirely; preserves canonicity of the sheaf-level statement at the cost of losing the named object for downstream consumers (Lie-algebra dual, etc.) |
  | (3) Blueprint alignment | High: `RigidityKbar.tex` § Piece (i) decomposition is built around the (i.a)/(i.b)/(i.c) trio with the named cotangent-at-identity object; iter-132 plan-phase writers already aligned the chapter to the (B) closure path | Low: would require a substantive blueprint rewrite of § Piece (i) to drop the (i.a) target and re-flow (i.b)+(i.c) around `Ω_{G/k}` directly; ~150–300 LOC of blueprint edits to absorb |
  | (4) Downstream API shape | The named `cotangentSpaceAtIdentity G` object is consumable by downstream code that needs the cotangent at identity as a first-class `k`-module (e.g. Lie-algebra dual, future `Module.Free k` / `Module.Finite k` companion lemmas, any rigidity argument re-framing) | Loses the named object; downstream consumers needing the cotangent at identity would need to extract it from `Ω_{G/k}` evaluated at the identity, which would require its own ad-hoc API |

  **Iter-133 decision**: STAY ON Replacement (B) under the iter-131 `Classical.choose`-chain body shape. Axis (1) LOC is within ~10% on a midpoint comparison (525 LOC for (B) vs 600 LOC for fibre-free) — the strategy-critic-iter132 `>20%` LOC pivot threshold is not crossed even on the conservative side. Axes (2)+(3)+(4) all favor (B) under the iter-131/iter-132 state: blueprint alignment is high, downstream API shape is concrete (the iter-132 close already names `cotangentSpaceAtIdentity_finrank_eq`, which is consumed by piece (i.c) and any future Lie-algebra-dual companion), and canonicity is the *only* axis where fibre-free wins — and that win is partially recovered by the iter-131 body shape exposing the structural form via `cotangentSpaceAtIdentity_eq_extendScalars`. **Pivot trigger preserved (renormalised iter-138)**: the iter-133 pivot threshold "if piece (i.b) ships at > 750 LOC alone" is **renormalised iter-138 to "> 1000 LOC cumulative (i.b)-side build"** per `strategy-critic-iter138` CHALLENGE on trigger asymmetry: the iter-137 `kaehler-tensorequiv-presheafpullback-iter137` analogist's revised universal-property route envelope (~360–710 LOC for Step 2 alone, ~410–810 LOC for piece (i.b) total) is the SAME evidence base that justified renormalising the (a')/(c) revert cap from 600 → 1000 LOC; leaving the fibre-free pivot threshold at 750 LOC while the (a')/(c) cap moved to 1000 LOC would be the partial-renormalisation pattern explicitly forbidden by the iter-138 renormalisation-discipline guardrail in § Soundness rules. The renormalisation is **bundled, one-shot, and grounded in the iter-137 analogist consult**; further renormalisation would require a NEW analogist consult. **iter-138-close 4-axis re-evaluation (MUST per `strategy-critic-iter138` Alternative #3 elevation from "may")**: after iter-138 prover lane returns on Step 2, re-run the 4-axis scorecard with the MEASURED (not projected) Step 2 body+helpers LOC. If axis (1) LOC for (B) flips against the (B) decision (i.e. measured LOC > the new 1000 LOC cap, OR > 70% of envelope upper bound while still below cap), the fibre-free re-evaluation fires unconditionally, with axes (1)+(2) (forward merit) explicitly weighted over (3)+(4) (switching cost) per iter-134 sunk-cost-flag awareness.

  **Forward-merit-vs-switching-cost weighting (iter-134 per `strategy-critic-iter134` CHALLENGE 2; sunk-cost-flag awareness)**: axes (1) LOC and (2) canonicity are **forward-merit** axes (they measure properties of the future shape of the codebase regardless of past investment). Axes (3) blueprint alignment and (4) downstream API shape carry **switching-cost flavor**: axis (3)'s "blueprint already aligned" is a description of past `RigidityKbar.tex` investment, and axis (4) names speculative downstream consumers (Lie-algebra dual; "any rigidity argument re-framing") that are NOT on the protected-declaration list and NOT downstream of any committed M2/M3 target. The iter-133 decision to STAY ON (B) is sound on the LOC differential alone (axis (1) within the iter-132 `>20%` pivot threshold), and the qualitative axes (2)+(3)+(4) reinforce it without flipping the call. **For the iter-138+ re-evaluation**: re-run the scorecard with the **measured** piece (i.b)+(i.c) LOC, and explicitly weight axes (1)+(2) (forward merit) over axes (3)+(4) (switching cost driven by past investment + speculative consumers). If axis (1) flips against (B) after measurement, axes (3)+(4) should NOT override; conversely, axis (4)'s speculative-consumer framing should be downgraded to "named-object utility for committed protected-declaration consumers only" before being treated as load-bearing. This applies the same self-flagging discipline the strategy already uses for ground (ii) "blueprint cleanliness" in the over-k re-defense section above.

- **`C(k) ≠ ∅` branch ℙ¹-specific rigidity hedge — RESOLVED iter-138, VERDICT NOT-VIABLE** (per `mathlib-analogist-p1-hedge-iter138`). Schedule was iter-133-advanced from iter-140+ to iter-135–138; iter-138 dispatch returned a NOT-VIABLE verdict. The hedge's prerequisite "weak ℙ¹ identification" has no Mathlib `b80f227` chain (no `ProjectiveSpace n S`, no Cartier/Weil divisors on smooth curves, no linear systems, no Riemann–Roch, no Brauer–Severi triviality); in-tree build cost ~1500–3000 LOC, on par with the iter-110 deferred Serre duality stack. Additionally: ring-side Frobenius "savings" are not free — `Differential.ContainConstants k (Polynomial k)` is NOT a Mathlib instance; the only registered instance is the trivial diagonal `ContainConstants A A`. Most importantly: **the hedge does NOT retire pieces (i.b)+(i.c)** — those trivialise the *target* `A`'s cotangent; the ℙ¹ identification lives on the *source* `C` side. Hedge cost ~2610–5240 LOC vs bundled pile ~1860–3540 LOC, strictly more expensive in expectation, with much wider build-risk tail. **Recommendation absorbed**: continue with the bundled pile (i.b)+(i.c)+(ii)+(iii); the iter-138 piece (i.b) Step 2 prover lane is validated as the right next step. **Piece (iii) scheme-level absolute Frobenius stays at 800–1500 LOC**; no compression to ring-side instances. If the pile stalls on (iii), prefer a named-gap sorry deferral over the hedge (which now has empirical NOT-VIABLE evidence, not just guessed). Persistent file: `analogies/p1-hedge-genus-zero-witness.md`.

  Historical context (preserved for traceability): The general over-k rigidity argument (`rigidity_over_kbar`) is built for arbitrary smooth proper geom-irr group-scheme codomain `A`. For the C(k) ≠ ∅ branch of M2.b specifically, a hypothetically cheaper sub-route was proposed: split `genusZeroWitness` by `Nonempty (𝟙_ _ ⟶ C)` and on the nonempty arm use a *ℙ¹-specific* rigidity. The iter-138 analogist verified this hypothesis empirically against Mathlib `b80f227` and rejected it. The C(k) = ∅ branch remains vacuous as discussed.

- **Standalone scheme-level cotangent sheaf — iter-129 re-evaluation engaged AND returned (per `strategy-critic-iter129` + `mathlib-analogist-lieAlgebra-rank-bridge-iter129`).** The iter-127 strategy named iter-129 as the formal re-evaluation trigger. The iter-129 plan-agent engaged the trigger and the analogist returned **ALIGN_WITH_MATHLIB on the body but PROCEED on the bundled-vs-unbundled decision**. Verdict in detail:

  - **The iter-128 body of `cotangentSpaceAtIdentity` is mathematically WRONG**: for every smooth proper geometrically irreducible `G/k` with relative dimension `n ≥ 1` (i.e. the entire target consumer class), the iter-128 evaluate-then-extend-scalars construction provably **collapses to the zero `k`-module**. Diagnostic (5-step): the relative-differentials *presheaf* at `op ⊤` is `KaehlerDifferential (φ'.app (op ⊤))` where `φ'.app (op ⊤)` collapses to the identity-ring-map `k → k` because (i) `Spec k`'s top is single-point so the pullback presheaf colimit collapses to `k`, and (ii) for proper geometrically integral `G/k`, `Γ(G, ⊤) = k` (Stacks 0BUG / `AlgebraicGeometry.isField_of_universallyClosed`). `KaehlerDifferential.subsingleton_of_surjective` then forces `Ω[k/k] = 0`; `extendScalars` of `0` is `0`. See `analogies/lieAlgebra-rank-bridge.md` for the full proof.

  - **Replacement (B), affine-chart base change, is the chosen body**: extract via `smooth_locally_free_omega` an affine chart `V ⊆ G.left` containing `η(pt)` with `Algebra.IsStandardSmoothOfRelativeDimension n Γ(Spec k, U) Γ(G, V)`; build `ψ_V : Γ(G, V) ⟶ k` from the identity-section restricted to V composed with `Scheme.ΓSpecIso`; set body to `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`. Closure path 50–100 LOC; NO Mathlib gaps under (B); piece (i) stays at the bundled 800–1500 LOC estimate. Trade-off: (B) is non-canonical (depends on chart choice via `Classical.choice`); for the rigidity consumer only the existence statement matters, so canonicality is not load-bearing.

  - **Replacement (C), standalone scheme-level cotangent sheaf — DEFERRED indefinitely**: 800–2000 LOC for the sheafified `Scheme.Ω`; no live consumer beyond the rigidity argument; (B) gives the same rank lemma at much lower cost. Re-evaluation trigger only if a downstream non-rigidity consumer materialises.

  - **Replacement (A), stalk-side `IsLocalRing.CotangentSpace` — DEFERRED**: 300–600 LOC bridge cost (`IsStandardSmooth at a prime ⇒ IsRegularLocalRing`); the canonical mathematical object, but bridge cost exceeds (B)'s 50–100 LOC. Re-evaluate if a future Lie-algebra-bracket consumer emerges.

  **Strategy implications**: the over-k path's piece (i) LOC envelope holds at 800–1500 LOC. The iter-127 "iter-129 unbundling re-evaluation" trigger is RESOLVED (not activated). **Iter-130 prover lane MUST swap the `cotangentSpaceAtIdentity` body to Replacement (B) before any rank-lemma dispatch** — see PROGRESS.md § "Iter-130 staged objectives" for the prover directive. The iter-129 blueprint-writer pass on `RigidityKbar.tex` (which authored the bridge lemma to `𝔪_{η_G} / 𝔪_{η_G}^2`) is closer to the Replacement (A) canonical framing; **iter-130 dispatches a same-iter blueprint-writer (`rigiditykbar-piecei-realign-iter130`) to re-align Piece (i) prose to Replacement (B)** in parallel with the prover lane (per iter-130 blueprint-reviewer's HARD GATE green-light-with-parallel-writer recommendation), so the chapter and Lean land in coherent shape at iter-131 review.

  **Iter-130 strategy-critic Q2 CHALLENGE (deferred-bridge concern for piece (i.b)).** The strategy-critic flagged that Replacement (B)'s chart-dependent body may not cleanly couple with the iter-130+ piece (i.b) `mulRight_globalises_cotangent` shear-iso step (which names the cotangent at identity as the fibre object of the trivialisation). Under (B) the fibre is non-canonical (chart-`Classical.choice`-dependent) while the LHS `Ω_{G/k}` is canonical, so the shear-iso globalisation may require a (B)→canonical bridge that (B) was supposed to avoid. The strategy's response (this iter):
  - The trigger (a') auto-revert clause already monitors piece (i.b) closure: if iter-131+ prover lane on `mulRight_globalises_cotangent` returns INCOMPLETE on a *functorial* shear-iso route and only closes when pointwise-translation through `k̄`-rational points is allowed, the project pivots back to over-`k̄` + M2.c. **Strengthened iter-130**: trigger (a') ALSO fires if the piece-(i.b) closure under (B) requires constructing the full (B)→(A) stalk-side bridge (~300–600 LOC per `analogies/lieAlgebra-rank-bridge.md`) inline; in that case the project re-opens the (A)-vs-(B) decision and may upgrade to (A) prospectively to amortise the bridge cost.
  - **Fibre-free piece (i) reformulation** (strategy-critic's "Alternative" proposal): prove `Ω_{G/k}` globally free of rank `n` via the shear iso applied directly to the differential sheaf, without ever naming a single "cotangent at identity" object. The strategy DOES NOT commit to this iter-130 (the Replacement (B) path is staged and Wave 2 dispatches the prover lane); but it is now a documented backup option. **Trigger**: if iter-131+ piece (i.b) closure fails under both (B) AND (A), dispatch a mathlib-analogist on the fibre-free reformulation before iter-132 prover work.

  These triggers preserve the iter-130 forward motion while honestly acknowledging the strategy-critic's Q2 concern is not fully resolved at the strategy-decision layer.

  **Iter-133 resolution of iter-130 strategy-critic Q2 (mathlib-analogist `mulright-globalises-cotangent-iter133`).** The iter-133 mathlib-analogist consult on piece (i.b) returned a clean PROCEED verdict with the iter-131 (B)-body composition, with the explicit recommendation to phrase the piece (i.b) Lean target with a **sheaf-level RHS** (`Ω_{G/k} ≅ pr_1^* (η_G^* Ω_{G/k})` in the presheaf-of-modules category) rather than a value-level RHS naming `cotangentSpaceAtIdentity G`. Under this phrasing, the (B)→(A) stalk-cotangent bridge concern that iter-130 Q2 worried about does NOT materialise: the bridge artefact piece (i.b) needs is a **chart-localisation identification** (~100–200 LOC, structurally distinct from the iter-130 worry's stalk bridge ~300–600 LOC), and this artefact is pushed into piece (i.c) (`omega_free` / `omega_rank_eq_dim`) rather than absorbed inline in piece (i.b). The piece (i.b) LOC envelope holds at **210–440 LOC** (within the original 200–500 LOC range). The fibre-free reformulation alternative was evaluated iter-133 on a 4-axis scorecard (LOC, canonicity, blueprint alignment, downstream API shape) and **stays deferred** — Replacement (B) wins on 3 of 4 axes; pivot trigger preserved if piece (i.b)/(i.c) actual LOC exceeds the envelope. Persistent file: `analogies/mulright-globalises-cotangent.md`.

**Iter-141+ scheduled obligations (committed iter-140 per `strategy-critic-iter140` Must-fix #3 + `mathlib-analogist-chart-algebra-rigidity-iter140` Major):**

- **Iter-141 (mandatory) piece (iii) scheme-Frobenius scoping analogist** — dispatch a dedicated mathlib-analogist on `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM against Mathlib `b80f227` with Stacks Tag 0CC4 as the construction reference and `Mathlib.Algebra.CharP.Frobenius` as the ring-side baseline. Inputs: Stacks Tag 0CC4 prose, the existing scheme-side functoriality conventions in `Mathlib.AlgebraicGeometry.Scheme.Functor`. Output: a per-sub-piece LOC estimate with idiom-alignment cost broken out. **Pivot criterion**: if revised estimate exceeds 2000 LOC, elevate the named-gap-sorry alternative from "active alternative" to "preferred default" with explicit STRATEGY.md revision. Co-fires with the iter-135–138-scheduled higher-Kähler-vanishing alternative analogist (which has slipped from its iter-135–138 window into iter-141+).
- **Iter-144 (MANDATORY) chart-algebra-vs-bundled re-evaluation** before committing the in-tree scheme-Frobenius build — dispatch `mathlib-analogist` with `analogies/direct-chart-algebra-rigidity-ib-ic.md` as the read-input (iter-140 verdict file). The piece-(iii) PHANTOM elimination (~800–1500 LOC; chart-algebra by-passes scheme-level Frobenius via ring-level `iterateFrobenius` on charts) is the single strongest pivot driver per the iter-140 chart-algebra-rigidity analogist HYBRID verdict. **Failure to re-evaluate at this gate is a sunk-cost trap.**

**Off-critical-path** (off-loop):
- M1 (presheaf-bridge): **EXCISED iter-126**. M1.d
  (`kaehler_quotient_localization_iso`) Mathlib-PR candidate remains
  in-tree as standalone utility; off-loop PR work proceeds from
  `analogies/relative-differentials-presheaf-bridge.md`.
- **M3 smallest-PR-piece identification (documentation only — RENAMED iter-141 per `strategy-critic-iter141` must-fix #6).** Previously labelled "M3 Route A Relative Spec functor off-loop PR lane" (iter-139 framing). The iter-140 honest classification + iter-141 name cleanup converge: this is **documentation in STRATEGY.md naming `Mathlib.AlgebraicGeometry.RelativeSpec` as the smallest PR-extractable M3 piece** (~700–1100 LOC; foundational for Hilbert scheme representability and Picard functor representability per the iter-123 M3 audit) — **not** an off-loop PR lane with infrastructure. The lane has zero in-loop iter-deliverables today, no in-tree scaffold, and no off-loop infrastructure (unlike the M1.d off-loop precedent whose `kaehler_quotient_localization_iso` is an actual in-tree declaration). The "off-loop PR lane" name was preserved across iter-139→iter-140 despite framing-downgrade; iter-141 renames to "documentation only" so the name matches the substance. **Alternative not adopted**: in-loop scaffold of `RelativeSpec` (~1 iter / +1 sorry / ~20 LOC) — Alternative #3 from `strategy-critic-iter140` recorded as available but not scheduled (M2 critical-path absorption higher-priority during the M2 wait window; scaffolding adds a sorry to the active count). Re-evaluation iter-150+ if M2 closure timeline extends materially.
- M3 (positive-genus witness): **user-hint absorbed iter-126**: the
  user explicitly endorsed "do the work, no axioms; ~6500–9000 LOC
  may not be that much for an AI". This resolves the iter-124
  TO_USER.md escalation in favor of the **PR-and-wait + do-the-work**
  direction (option 1). The named-axiom alternative (option 2) is
  REJECTED. M3 stays off the iter-by-iter critical path until M2
  has closed (M2 first, M3 after); during the M2 wait window the
  loop produces upstream-PR candidates from M1.d (off-loop) and
  the iter-126 mathlib-analogist consult on the shared cotangent-
  vanishing pile drives the M2 build-out.

The genus-stratified body restructure of `nonempty_jacobianWitness`
(the `by_cases h : genus C = 0` decomposition) lands once
`genusZeroWitness` (M2 output) and `positiveGenusWitness` (M3 output)
are at least scaffolded with sorry-bodies. The estimated iter for
this restructure is post-M2.b / post-M3-scaffolding, i.e. multi-month
away.

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

- `AbelJacobi.tex` (89 LOC) — Abel-Jacobi map of a curve via `Jacobian.ofCurve` + uniqueness factorisation; chapters for `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`.
- `AlgebraicJacobian_Cotangent_GrpObj.tex` (82 LOC) — pointer chapter for `Cotangent/GrpObj.lean`; cross-refs the substantive content (which is in `RigidityKbar.tex`).
- `Cohomology_MayerVietoris.tex` (947 LOC) — Čech / Mayer–Vietoris infrastructure for `genus`.
- `Cohomology_SheafCompose.tex` (40 LOC) — sheaf composition lemmas used by Mayer–Vietoris.
- `Cohomology_StructureSheafAb.tex` (78 LOC) — structure-sheaf-AbGrp side of `genus`.
- `Cohomology_StructureSheafModuleK.tex` (655 LOC) — structure-sheaf-Mod-k side of `genus`.
- `Differentials.tex` (209 LOC) — `relativeDifferentialsPresheaf`, `smooth_locally_free_omega`, and M1.d Mathlib-PR candidate `kaehler_quotient_localization_iso`.
- `Genus.tex` (69 LOC) — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` definition + properties.
- `Jacobian.tex` (450 LOC) — `Jacobian` definition + genus-stratified `nonempty_jacobianWitness` body decomposition + `genusZeroWitness` + `positiveGenusWitness` scaffolds.
- `Rigidity.tex` (71 LOC) — Mumford rigidity for pointed proper smooth morphisms.
- `RigidityKbar.tex` (1349 LOC) — over-k rigidity argument; piece (i.a) `cotangentSpaceAtIdentity`, piece (i.b) `mulRight_globalises_cotangent` shear-iso globalisation with Step 1/2/3 + Main composition, piece (i.c) `omega_free`/`omega_rank_eq_dim`, piece (ii) `Scheme.Over.ext_of_diff_zero`, piece (iii) scheme-level absolute Frobenius. Iter-141 grew this chapter by +125 LOC (d_app + d_map + IsIso closure recipes for piece (i.b) Step 2).

## Prior critique status

`strategy-critic-iter141` returned **CHALLENGE** with 7 axes audited (4 CHALLENGE / 0 REJECT), 6 must-fix items, 5 sunk-cost flags, 3 alternative routes. Route-pivot question (over-k vs over-`k̄`) was REJECTED-AS-WRONG-QUESTION (piece (i.b) Step 2 is base-independent). Iter-141 prover-lane shape verdict: **(C) primary + (B) follow-on, NOT (A), NOT (D)**.

Iter-141 absorbed 4 substantive STRATEGY.md edits (per the iter-141 sidecar):
- **Edit 1 (line 489)**: "Multi-month wait window" → "Multi-year wait window" header re-sync with iter-140 multi-year wall-clock correction.
- **Edit 2 (~line 597)**: M3 PR lane "off-loop PR lane" → "documentation only" rename.
- **Edit 3 (line 421)**: SYMMETRIC LOC trigger arm renormalisation discipline (tighten-when-piece-closes-under-envelope arm added).
- **Edit 4 (line 544/546)**: Decouple CHURNING-trigger from pre-committed strategy-critic question (CHURNING-triggers now name diagnostic questions, NOT pre-committed answers).

Please re-verify all 4 iter-141 STRATEGY.md edits are internally consistent and that no asymmetric or wrong-question residue remains.

Live carry-over questions (from prior critique cycles):
- 5-consult arm watchpoint on iter-150 revisit (iter-140 STRATEGY.md Edit 1; reinforced by iter-141 strategy-critic Edit 1 residual concern).
- Iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation gate on piece (iii) scheme-Frobenius (per iter-140 Must-fix #3 + iter-141 Wave 1 scheme-Frobenius scoping analogist HYBRID verdict — in-tree LOC midpoint ~1025 stays below 2000 LOC pivot threshold, but chart-algebra alternative remains LOC-dominant at 450–900 LOC vs full in-tree 980–1970 LOC).

Iter-142 is the first iter after iter-141's plan-only deferral; the iter-141 plan agent committed iter-142 to a prover lane on `Cotangent/GrpObj.lean` piece (i.b) Step 2 BUNDLED 3-sub-sorry closure (d_app L624 + d_map L643 + IsIso L689 inside `(fun _ => sorry)`). All blueprint recipes are in `RigidityKbar.tex` (1349 LOC) plus persistent analogy files `analogies/d-app-d-map-recipe-shape.md` + `analogies/isiso-basechange-along-proj-two-inv.md`.
