# Strategy Critic Directive

## Slug
iter129

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian challenge (`references/challenge.lean`). The keystone theorem is:

```
theorem AlgebraicGeometry.nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C)
```

— the existence of a Jacobian witness (an Albanese variety together with the universal-pointed-morphism property) for an arbitrary smooth proper geometrically irreducible curve `C` of relative dimension 1 over a field `k`. The signature is frozen by the mathematician; no `k`-rational-point hypothesis, no genus parameter. The remaining eight protected declarations (`genus`, `Jacobian` group-scheme structure, `Jacobian.ofCurve` / `Jacobian.comp_ofCurve` / `Jacobian.exists_unique_ofCurve_comp`) all reduce to the existence of this witness (currently `Classical.choice (nonempty_jacobianWitness C)`).

Project end-state: zero inline `sorry`, no named axioms.

## Strategy under review

(paste STRATEGY.md verbatim below)

---

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

The end-state is **zero inline `sorry` in the project**. There are no
deferred tasks; every gap is on the active roadmap. The roadmap is
multi-month, decomposed into milestones M1, M2, M3 with sub-step
detail and per-step effort estimates. Iter-by-iter `PROGRESS.md`
schedules the next concrete sub-step.

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
| M2.d-alt → **renamed M2.body-pile** iter-127 (per `strategy-critic-iter127` CHALLENGE: piece (iv) deferral foreclosed the original "genus-0 identification" arm; the pile now covers only M2.a body, not genus-0 identification) | **Cotangent-vanishing rigidity pile** — gates M2.a body closure (C.2.d). The pile (pieces (i)+(ii)+(iii)) is the iter-128+ shared build: (i) **group-scheme cotangent triviality** as `AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` (per `cotangent-vanishing-pile-iter126` analogist naming-idiom alignment — Mathlib `b80f227` has no `AbelianVariety` file; `GrpObj` namespace per Yang+Merten 2026); (ii) **scheme-level df=0 ⇒ factors-through-Spec-k** as `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (ring-level half aligns with Mathlib `Differential.ContainConstants`); (iii) **char-`p` Frobenius iteration** (committed Option A per iter-126 analogist; uses absolute Frobenius `F_X`, not relative). **Piece (iv) Serre duality DEFERRED** as named-gap; **the deferral forecloses any "genus-0 identification" use case** of the pile. The pile under iter-127's over-k commitment covers ONLY M2.a body closure. | Mathlib: `AlgebraicGeometry.GrpObj.omega_*` PHANTOM; `Mathlib.RingTheory.Derivation.DifferentialRing` `ContainConstants` typeclass (verified) for piece (ii) ring-level alignment; `Mathlib.Algebra.CharP.Frobenius` for ring-level Frobenius; **scheme-level absolute Frobenius `F_X` is a substantial Mathlib gap with NO precedent in `b80f227`** (per `strategy-critic-iter128` CHALLENGE; `lean_local_search` "Frobenius" returns only ring-side `Mathlib.Algebra.CharP.Frobenius` + `NumberTheory.FrobeniusNumber`; no `AlgebraicGeometry.Scheme.frobenius`). | **Pile (i)+(ii)+(iii) total (iter-128 revised): 1850–3600 LOC over 9–20 iter** (piece (i) 800–1500 LOC / 5–10 iter; piece (ii) 250–500 LOC / 2–3 iter; piece (iii) **revised 800–1500 LOC / 4–7 iter** per `strategy-critic-iter128` honest-LOC accounting on the missing scheme-level Frobenius); piece (iv) DEFERRED (n/a). The over-k path still nets net savings vs. over-`k̄`+M2.c because Galois-descent of morphism equality (M2.c, 4–8 iter / 300–500 LOC) is eliminated; but the over-k savings drop from "7–13 iter / 500–900 LOC" to **"2–6 iter / 0–500 LOC"** under the revised piece (iii) accounting. The over-k commitment remains net-positive but the case is narrower. |

**Sub-step dependency (iter-127, over-k path)**: M2.b depends on M2.a (rigidity over k). M2.a body depends on the shared pile (pieces (i)+(ii)+(iii)). The chain is linear: pile (i) → pile (ii) → pile (iii) → M2.a body → M2.b body closure → genus-stratified body of `nonempty_jacobianWitness`.

**Standalone-cotangent-sheaf alternative (per `strategy-critic-iter127` critical alternative).** The iter-126 analogist's piece (i) decomposition bundles a "presheaf-vs-sheaf bridge cost" into its 800–1500 LOC estimate. The strategy critic proposes treating the **scheme-level cotangent sheaf** as a standalone Mathlib-PR target ahead of piece (i), with two claimed benefits: (a) the cotangent sheaf is independently useful Mathlib infrastructure (consumed by RR, smoothness criteria, surface theory); (b) front-loading it would reduce piece (i)'s estimate from 800–1500 LOC to ~400–800 LOC.

**Plan-agent verdict (iter-127): DEFER, do not unbundle now.** The presheaf-level path is already committed via the project's existing `relativeDifferentialsPresheaf` and is consistent with the iter-126 analogist's bundled estimate. Unbundling would: (i) require dispatching a separate analogist to scope the cotangent-sheaf gap precisely; (ii) delay piece (i) by 5–8 iter; (iii) introduce a parallel-build coordination cost. Under the iter-126 user hint ("do the work; shortest path among legitimate options"), the bundled path is shorter even if individually less PR-clean. **Revisit at iter-129 if piece (i) build reveals the bridge cost is substantially worse than estimated.** If the bridge alone exceeds 500 LOC during iter-129+ build, dispatch a follow-up analogist on the standalone cotangent-sheaf alternative.

**Serre-duality cost-accounting reconciliation (per `strategy-critic-iter127` critical alternative).** Prior STRATEGY.md had Serre duality buried inside M2.d's 1500–3000 LOC total AND named standalone in the M2.d-alt piece (iv) at 3000–8000 LOC. These were inconsistent. Reconciled iter-127:

- **Serre duality is a shared top-level dependency** consumed by (a) M2.d (RR path; fallback, NOT ACTIVE under over-k commitment); (b) M2.d-alt piece (iv) (genus-0 identification arm; DEFERRED under iter-127's over-k commitment).
- Honest standalone estimate: **3000–8000 LOC** per `analogies/serre-duality.md` iter-110 verdict.
- Status under iter-127's over-k commitment: **NOT NEEDED for M2.a body closure** (the pile is (i)+(ii)+(iii) only). Serre duality re-enters the project's critical path only if M2.d-alt piece (iv) is needed for some future genus-0 identification statement that the over-k rigidity does not subsume.

### M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

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
- **Gap (group-scheme cotangent triviality, `GrpObj.omega_free` / `omega_rank_eq_dim` PHANTOM)**: subsumed by milestone M2.body-pile piece (i).
- **Gap (scheme-level `df=0 ⇒ factors-through-Spec-k`, `Scheme.Over.ext_of_diff_zero` PHANTOM)**: subsumed by milestone M2.body-pile piece (ii).
- **Gap (scheme-level absolute Frobenius, `AlgebraicGeometry.Scheme.absoluteFrobenius` PHANTOM)**: subsumed by milestone M2.body-pile piece (iii). **Honest size (per `strategy-critic-iter128`): 800–1500 LOC over 4–7 iter** (revised from iter-127's 300–600 LOC / 2 iter). The project must build the scheme-level Frobenius from the ring-side `Mathlib.Algebra.CharP.Frobenius` — Mathlib `b80f227` has NO scheme-level Frobenius at all (`lean_local_search` "Frobenius" returns only `NumberTheory.FrobeniusNumber.lean`, unrelated). Stacks Tag 0CC4 is the canonical reference for the scheme-level construction.
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

**Multi-month wait window (revised iter-127 — over-k path commitment shaved 7–13 iter / 500–900 LOC from the prior over-`k̄` baseline).** Parallel productive lanes (with HONEST iter-ranges):

| Iter range | Lane | Output | Per-row iter cost |
|---|---|---|---|
| 125 | Rigidity refactor (DONE) | `Scheme.Over.ext_of_eqOnOpen` lands; blueprint cross-refs updated | 1 iter |
| 126 | M2.a scaffold + over-`k̄` analogist (DONE) | (a) `rigidity_over_kbar` named declaration scaffolded with a `sorry` body; (b) mathlib-analogist consult on the over-`k̄` shared pile pulled forward from iter-130. | 1 iter |
| 127 | M2.b scaffold + over-k analogist + strategic refactor (THIS ITER, DONE) | (a) `genusZeroWitness` defined as a `JacobianWitness C` builder with single `sorry` body (`Jacobian.lean:174–178`); (b) over-k mathlib-analogist consult returned OK_OVER_K on all three pile pieces, **adopting the over-k path**; (c) STRATEGY.md revised to drop M2.c + M2.c.aux; (d) blueprint-writer dispatches for piece (i) sub-decomposition + Jacobian.tex genusZeroWitness block to stage iter-128 prover lane per iter-126 META-PATTERN TRIPWIRE. | 1 iter |
| 128 (THIS ITER) | Piece (i.a) scaffold + first prover lane (META-PATTERN TRIPWIRE fires; iter-128 RE-SCOPED per `strategy-critic-iter128` CHALLENGE) | **Refactor**: scaffold ONLY `AlgebraicGeometry.GrpObj.lieAlgebra` (the *definition* of the cotangent at the identity as a `k`-module; NO rank lemma this iter) in new file `AlgebraicJacobian/Cotangent/GrpObj.lean`, with `sorry` body. **Prover dispatch** on the same declaration immediately after the refactor lands. The rank lemma `lieAlgebra_finrank_eq_dim` is deferred to iter-129+ for two reasons: (i) the rank's RHS Lean encoding (`n` parameterised by `[SmoothOfRelativeDimension n G.hom]` instance) needs blueprint pinning iter-129 before being prover-ready; (ii) bundling definition + rank into one iter-128 prover task is borderline-too-ambitious per `progress-critic-iter128`. **Rename `rigidity_over_kbar` → `rigidity_over_k`** is deferred to iter-129 as a low-priority cleanup refactor; iter-128 stays focused on the prover lane. | 1 iter (refactor + prover dispatch + iter-129 fallback rule codified) |
| 129–139 (5–11 iter) | **Piece (i) body** — group-scheme cotangent triviality body closure (Lie-algebra-of-`GrpObj` + mulRight-globalisation via the shear iso `(a, b) ↦ (a, a·b)` + relative-cotangent-presheaf trivialisation, on top of the project's existing `relativeDifferentialsPresheaf`, inheriting the presheaf-vs-sheaf bridge cost from `analogies/cotangent-presheaf-design.md`). Per the iter-127 over-k analogist's risk register, formulate the globalisation step **functorially via the shear iso**, NOT via pointwise translation requiring `k̄`-rational points. iter-128 lands piece (i.a) definition; iter-129+ closes (i.a) rank lemma; iter-130+ closes (i.b) shear-iso globalisation; iter-133+ closes (i.c) freeness conclusion. | 800–1500 LOC. | 5–11 iter |
| 140–142 (2–3 iter) | **Piece (ii)** — scheme-level `df=0 ⇒ factors-through-Spec-k` (`AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`; ring-level half aligns with Mathlib's `Differential.ContainConstants`; k-agnostic per iter-127 over-k analogist). | 250–500 LOC. | 2–3 iter |
| 143–149 (4–7 iter) | **Piece (iii)** — char-`p` Frobenius iteration (committed Option A per iter-126 + iter-127 analogists; consumes `Mathlib.Algebra.CharP.Frobenius`; scheme-level lift uses **absolute** Frobenius `F_X`, intrinsic to `X` — no perfectness/alg-closure required). **Revised iter-128 honest LOC accounting** (per `strategy-critic-iter128`): the project must FIRST build `AlgebraicGeometry.Scheme.absoluteFrobenius` (or equivalent) — there is NO scheme-level Frobenius in Mathlib `b80f227` (`lean_local_search` confirms only ring-side `Mathlib.Algebra.CharP.Frobenius` + `NumberTheory.FrobeniusNumber`). Stacks Tag 0CC4 sketches the scheme-level construction (functorial p-th-power on rings, sheafified to `Scheme ⟶ Scheme`, smoothness compatibility, $F_{X/k}$ vs $F_X$ relationship). | **revised 800–1500 LOC** (was 300–600). | **revised 4–7 iter** (was 2). |
| **Piece (iv)** | **DEFERRED as named-gap** (Serre duality). Used only by M2.d genus-0 identification arm (NOT ACTIVE under iter-127 over-k commitment). The iter-128+ shared-pile build does NOT include it. | Serre duality 3000–8000 LOC per `analogies/serre-duality.md` iter-110 verdict. | n/a (deferred) |
| ~~M2.c assembly~~ | **DROPPED iter-127** per over-k analogist. | n/a | **eliminated**: −4–8 iter / −300–500 LOC. |
| ~~M2.c.aux `geomIrred.exists_kalg_pt`~~ | **DROPPED iter-127**. | n/a | **eliminated**: −3–5 iter / −200–400 LOC. |
| 150–151 (1–2 iter) | M2.a body closure | Apply pieces (i)+(ii)+(iii) to close `rigidity_over_kbar` (or post-rename `rigidity_over_k`) body. | 1–2 iter / 50–150 LOC. |
| 152–153 (1–2 iter) | M2.b body closure | Close `genusZeroWitness` body using `rigidity_over_k` + terminal-object infrastructure. | 1–2 iter / 100–200 LOC. |
| 154+ | M2 closure | Genus-stratified body restructure of `nonempty_jacobianWitness` (the `by_cases h : genus C = 0` decomposition), gated also on M3 scaffolding. | 2–4 iter. |

**Honest M2 closure estimate (iter-128, revised over-k variant): iter-149 to iter-167+** (pieces (i)+(ii)+(iii) total 1850–3600 LOC over 9–20 iter starting iter-128; M2.a body closure iter-150+; M2 closure iter-154+ gated on M3 scaffold). **Saving vs prior over-`k̄` baseline (revised iter-128): ~2–6 iter / 0–500 LOC** (the dropped M2.c + M2.c.aux nets a smaller saving once piece (iii) honest-Frobenius LOC is corrected per `strategy-critic-iter128`; the over-k commitment remains net-positive but the case is narrower than the iter-127 framing suggested). The iter-128 sequencing supersedes the iter-127 "iter-143 to iter-157+" estimate.

The 9–20 iter range for the pile breaks down as: piece (i) 5–11 iter (definition-only iter-128 + rank-lemma iter-129+ + (i.b) shear + (i.c) freeness),
piece (ii) 2–3 iter, piece (iii) **4–7 iter** (revised iter-128; scheme-level absolute Frobenius is missing from Mathlib `b80f227` and the project must build it on the way) — in sequence; (i) must close
before (ii) and (iii) can build.

**Direct over-k rigidity — COMMITTED iter-127** (per `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` OK_OVER_K verdict). The cotangent-triviality argument is intrinsic (the shear iso `(a, b) ↦ (a, a·b)` is a scheme map over any base); pieces (i)+(ii)+(iii) build directly over any base field `k`; M2.c (Galois descent) and M2.c.aux (`geomIrred.exists_kalg_pt`) are eliminated. The iter-126 scaffold's Lean signature is already k-agnostic. **Risks** (per the analogist's risk register; revert option preserved):

- Piece (i) **must use the functorial shear-iso globalisation**, not pointwise translation. Pointwise translation would require `k̄`-rational points to translate the cotangent at the identity to a frame on the whole group; the shear iso avoids this.
- Piece (iii) **must use absolute Frobenius `F_X`** (intrinsic to `X`, independent of base), not relative Frobenius `F_{Y/k}` (which over non-perfect `k` would require `[PerfectField]`).
- **Revert option (with concrete triggers per `strategy-critic-iter128` sunk-cost flag)**: if **any one** of (a) iter-128 prover lane on `lieAlgebra` returns INCOMPLETE on a *functorial* shear-iso-style argument and only closes if pointwise translation is allowed; (b) piece (iii) build at iter-143+ exceeds **1200 LOC** while less than 50% complete; (c) iter-129 mathlib-analogist on `lieAlgebra` (fallback rule below) reports that the over-k pullback-along-section bridge demands materially more infrastructure than the over-`k̄` version, **revert to the over-`k̄` baseline + reintroduce M2.c**. Cost of revert: ~1 iter of strategic backtrack + restoration of M2.c rows. **Trigger (a) is checkable iter-128 close; triggers (b)/(c) are iter-129+ deferred.**

**Off-critical-path** (off-loop):
- M1 (presheaf-bridge): **EXCISED iter-126**. M1.d
  (`kaehler_quotient_localization_iso`) Mathlib-PR candidate remains
  in-tree as standalone utility; off-loop PR work proceeds from
  `analogies/relative-differentials-presheaf-bridge.md`.
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


---

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

(persistent design files at `analogies/`: `cotangent-vanishing-pile.md`, `cotangent-vanishing-pile-over-k.md`, `cotangent-presheaf-design.md`, `relative-differentials-presheaf-bridge.md`, `serre-duality.md`, `m3-route-audit.md`. Do not read these unless a strategic claim under review cites them.)

## Blueprint summary (chapter titles + one-line topic)

- `AbelJacobi.tex` — Abel–Jacobi map: definition + universal property; reduces to `JacobianWitness`.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris machinery for sheaf cohomology of curves (consumed by Genus).
- `Cohomology_SheafCompose.tex` — Sheaf composition with forget functor (Phase A infra).
- `Cohomology_StructureSheafAb.tex` — Structure sheaf as Ab-valued sheaf (Phase A step 2–4).
- `Cohomology_StructureSheafModuleK.tex` — Structure sheaf as ModuleCat-k-valued sheaf (heavy: 655 LOC); Čech + acyclic-cover producers.
- `Differentials.tex` — Relative differentials presheaf `Ω_{X/S}` on a scheme morphism; M1 bridge EXCISED iter-126; standalone utilities `relativeDifferentialsPresheaf`, `kaehler_quotient_localization_iso` (Mathlib-PR candidate), `smooth_locally_free_omega`.
- `Genus.tex` — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`; complete.
- `Jacobian.tex` — JacobianWitness structure (Albanese-variety-with-universal-property); IsAlbanese; genus-stratified body of `nonempty_jacobianWitness` (iter-127 `genusZeroWitness` scaffold; positive-genus `positiveGenusWitness` is M3-future).
- `Modules_Monoidal.tex` — Monoidal structure on ModuleCat; possibly orphan post-iter-127 (flagged in iter-128 blueprint-reviewer for deletion).
- `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex` — Picard scheme machinery (Route A for M3); possibly orphan post-iter-127.
- `Rigidity.tex` — Mumford rigidity over a field: `Scheme.Over.ext_of_eqOnOpen` (point-equality at a dense open + proper-separated target ⇒ scheme-equality); CLOSED iter-125.
- `RigidityKbar.tex` — Rigidity for `f : C → A` from genus-0 curve to group scheme over arbitrary base field `k` (over-k commitment iter-127). Iter-126 scaffold `rigidity_over_kbar`; iter-128 added `lieAlgebra` Lean declaration to `Cotangent/GrpObj.lean` (piece (i.a)). Piece (i)+(ii)+(iii) decomposition for the cotangent-vanishing pile.

## Specific concerns for this iter

The strategy was substantively revised at iter-128 in five places per the iter-128 `strategy-critic-iter128` CHALLENGE (4 challenges all adopted): piece (iii) honest LOC re-sized 300–600 → 800–1500; piece (i.a) blueprint Lean encoding pinned; iter-128 prover lane re-scoped to definition-only; user-hint citation discipline added; revert-option triggers concretised. None of these are NEW changes for iter-129 — they are the iter-128 state, now stable.

Specific spot-checks I'd like (treat as suggestions, not constraints):

1. The iter-128 revert-trigger (a) — "iter-128 prover INCOMPLETE on functorial shear-iso closes" — did NOT fire (iter-128 prover lane returned COMPLETE on a pullback-along-section bridge, NOT the shear iso). Does the revert option's trigger (a) still make sense as written, or should it be rephrased in light of which closure route iter-128 actually used?

2. The iter-128 chose to keep the rank-lemma `lieAlgebra_finrank_eq_dim` deferred to iter-129+. The blueprint route for the rank lemma is "$\mathfrak{m}/\mathfrak{m}^2$ at the identity → cotangent space via `IsRegularLocalRing.cotangentSpace`", but the iter-128 prover lane's body construction took a different (evaluate-then-extend-scalars) route. Is the strategy honest about the bridge cost between these two presentations?

3. The over-k commitment's net savings are now revised to "2–6 iter / 0–500 LOC" (down from 7–13 iter / 500–900 LOC at iter-127). Is this still net-positive given the smaller margin? Should the standalone-cotangent-sheaf alternative (per iter-127 `strategy-critic-iter127`) be reactivated as a hedge?

## Output format

Per § "What you check" of `.archon/subagents/strategy-critic.md`. Verdicts: SOUND / CHALLENGE / REJECT per route. CHALLENGEs must be addressed by the plan agent (either STRATEGY.md update or explicit rebuttal in iter-129 plan sidecar).
