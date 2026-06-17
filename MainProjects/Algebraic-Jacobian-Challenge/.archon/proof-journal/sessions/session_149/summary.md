# Session 149 (iter-149) — Review summary

## Session metadata

- **Iteration**: 149 (Archon canonical)
- **Two-lane prover dispatch** completed: Lane 1 = NEW file `Cotangent/ChartAlgebraS3.lean`; Lane 2 = `Cotangent/ChartAlgebra.lean`.
- **Sorry count delta** (declarations using `sorry`): **5 → 9** (NET **+4**, structural decomposition advance — see "Net trajectory" below).
- **Per-file at iter-149 close** (verified via `sorry_analyzer`):
  - `Cotangent/ChartAlgebra.lean` — **2** sorries (L194 KDM (BR.5) joint-kernel collapse; L423 hPI branch of `constants_integral_over_base_field`).
  - `Cotangent/ChartAlgebraS3.lean` — **4** sorries (S3.sep.1 L166, S3.pi.1 L227, S3.sep.2 L269, S3.pi.2 L320).
  - `Cotangent/GrpObj.lean` — 0 (unchanged).
  - `Jacobian.lean` — 2 (unchanged).
  - `RigidityKbar.lean` — 1 (unchanged).
- **`meta.json`**: `planValidate.status: ok / objectives: 2`; both prover lanes `status: done`; `prover.durationSecs: 1330` (~22 min).
- **Build state**: clean compile across both lanes (`lake env lean` exit 0, only `sorry` warnings on the 6 file-scope declarations using sorry).
- **Files edited** (per `attempts_raw.jsonl` summary): 4 (`AlgebraicJacobian.lean` umbrella, `Cotangent/ChartAlgebra.lean`, NEW `Cotangent/ChartAlgebraS3.lean`, `blueprint/src/content.tex` for chapter registration).
- **Edits / goal checks / diagnostic checks / lemma searches**: 13 / 2 / 20 / 54.

## Net trajectory

Iter-149 is the iter-148 review's REC-1/REC-2 absorption + the iter-149
progress-critic's CHURNING corrective. The strict sorry-count
INCREASE (5 → 9) reflects **structural decomposition**: the iter-148
consolidated conjunction sorry `IsPurelyInseparable k Γ ∧
Algebra.IsSeparable k Γ` is split into two named branches, ONE of
which (b.1 hSep) is fully closed project-internally; the other (b.2
hPI) is a structured sorry. Lane 1 simultaneously promotes the four
(S3.\*) sub-claims to first-class declarations with correct
blueprint-mandated signatures and structured `sorry` bodies — adding
+4 named decls but providing the iter-150+ closure-target landscape
that the iter-148 review explicitly asked for.

Trajectory across iter-146..149 (chart-algebra route on the path
(b) reduction):

- iter-146 close: 8 file-decls / 8 inline sorries.
- iter-147 close: 6 / 6 (β-core closed; KDM split; constants substep 3 rewritten).
- iter-148 close: 5 / 5 (path (b) smart-proof framework landed; KDM forward (p2) bridge body docstring + sub-decomposition).
- iter-149 close: **9 / 9** (4 first-class (S3.\*) decls added; hSep branch in-tree-closed; hPI branch as structured sorry).

The 4-unit increase is the planner-authorised consequence of
landing first-class signatures for the (S3.\*) sub-claims; each is
now an iter-150+ closure target with named Mathlib bridges (or
explicit Mathlib gaps) catalogued in-source.

## Per-target outcome

### Lane 1 — `Cotangent/ChartAlgebraS3.lean` (NEW FILE, 322 LOC)

Created the new file with `import AlgebraicJacobian.Cotangent.GrpObj`
plus 7 Mathlib namespaces and 2 helper definitions:

- `gammaAlgebraMap k X` — canonical `k → Γ(X, O_X)` ring map.
- `gammaAlgebra k X` — `Algebra k Γ(X, O_X)` instance
  (`@[reducible] noncomputable def`).

These match the local `algkΓ` construction inside
`constants_integral_over_base_field` (Lane 2 consumer)
definitionally, so the Lane 2 consumer can substitute `letI :=
gammaAlgebra k X`.

Added to `AlgebraicJacobian.lean` umbrella in import order before
`Cotangent.ChartAlgebra`. Added `\input{chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3}`
to `blueprint/src/content.tex` and created the new pointer chapter
`blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex`.

**Four scaffolded declarations** (all PARTIAL — structured `sorry`
with documented closure paths):

1. **(S3.sep.1)** `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`
   at L124. Signature matches blueprint
   `lem:S3_sep_1_smooth_geometrically_reduced_Gamma`. 4-step closure
   path inline: Smooth ⇒ GeometricallyReduced morphism class (Mathlib
   gap) ⇒ each pullback X_K reduced ⇒ apply (S3.pi.1) ⇒ specialise
   to `\bar k`. **Stacks Tag 04QM** is the upstream anchor.
2. **(S3.pi.1)** `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`
   at L167. Signature uses
   `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(XK))` idiom with `XK`
   constructed via `pullback (X ↘ Spec k) (Spec.map (algebraMap k K))`.
   5-step closure path inline: cover by affines (qcompact from
   properness), Čech equalizer, flat-tensor preserves equalizer,
   affine chart-by-chart Stacks 00DS, reassemble. **Stacks Tag
   02KH** specialised to H^0 = Γ row. **Deepest sub-claim**;
   PARTIAL explicitly authorised.
3. **(S3.sep.2)** `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
   at L199 (the `_root_` namespace placement is intentional —
   matches the upstream `Algebra.IsSeparable` family). Signature:
   `[Algebra.IsGeometricallyReduced k F] [FiniteDimensional k F]`
   ⇒ `Algebra.IsSeparable k F`. 6-step Artinian-product closure
   path inline. **Stacks Tag 0BJF**.
4. **(S3.pi.2)** `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
   at L269 (`_root_`). Signature uses
   `(minimalPrimes (TensorProduct k (AlgebraicClosure k) F)).Subsingleton`.
   5-step closure path inline via
   `isPurelyInseparable_of_finSepDegree_eq_one` +
   Artinian-residue-field chase. **Stacks Tag 05DH**.

**Net Lane 1 contribution**: +1 file, +4 first-class decls, +2
helper defs, +1 blueprint chapter, +1 `content.tex` registration.
0 sorries closed (this lane's mission was signature-scaffolding +
unblock Lane 2 consumer).

### Lane 2 — `Cotangent/ChartAlgebra.lean`

**Signature inflations propagated (BR.1)**:

- `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (L123):
  added `[CharZero k]` + `{n : ℕ}` +
  `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`.
- `GrpObj.df_zero_factors_through_constant_on_chart` (L222):
  same hypotheses propagated to consumer; body remains the
  one-line delegate to the KDM helper with `(n := n)` explicit
  binder.

**KDM body advance (BR.2)–(BR.4)** (L123–L194):

- `(BR.2)` Extracted `Algebra.IsStandardSmooth k B` from the
  relative-dimension class via the named theorem
  `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n`
  (the class is a `Prop`, not registered as an instance).
- `(BR.2 cont.)` Obtained `Module.Free B (Ω[B⁄k])` via
  `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
- `(BR.3)` Picked basis via `Module.Free.chooseBasis B (Ω[B⁄k])`;
  extracted coordinate derivations `(basis.coord i).compDer
  (KaehlerDifferential.D k B) : Derivation k B B`.
- `(BR.4)` Proved `_hCoordVanish : ∀ i, ((basis.coord i).compDer D) b
  = 0` via one-line `simp [Derivation.coe_comp, hDb]`.
- `(BR.5)` JOINT-KERNEL COLLAPSE — the substantive remaining gap.
  Closure-path comment block documents the coordinate-induction
  argument on the standard-smooth presentation
  `B ≅ k[x_1, …, x_n, y_1, …, y_m] / (f_1, …, f_m)` with invertible
  Jacobian; Stacks Tag **07F4**. Residual `sorry` at L194.

**Constants substep 3 conjunction split + hSep branch closed**
(L394–L457):

- Split `have ⟨hPI, hSep⟩ : IsPurelyInseparable k Γ ∧
  Algebra.IsSeparable k Γ := by refine ⟨?_, ?_⟩` into two named
  branches.
- **hPI branch (b.2)**: structured `sorry` at L423 with 5-step
  base-change-to-`\bar k` closure chain documented inline ((i)
  GeometricallyIrreducible ⇒ IrreducibleSpace X_{\\bar k}, (ii)
  Smoothness ⇒ IsReduced X_{\\bar k} (Mathlib gap: smooth ⇒
  reduced over perfect base, base-change stable), (iii) combine
  to IsIntegral, (iv) apply (S3.pi.1) iso, (v) apply (S3.pi.2)).
  Iter-150+ closure point.
- **hSep branch (b.1)**: **CLOSED project-internally** (no
  project-side sorry).
  1. Wire `(S3.sep.1)` via
     `haveI _hGR : Algebra.IsGeometricallyReduced k Γ :=
     AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`.
  2. Construct `Module.Finite k Γ` bridge from
     `_hAppTopFinite : (.appTop.hom).Finite` via the chain
     `CategoryTheory.Iso.commRingCatIsoToRingEquiv (Scheme.ΓSpecIso
     (.of k))` → `RingEquiv.symm.finite` → `RingHom.Finite.comp`
     → `RingHom.finite_algebraMap.mp`. The bridge collapses to
     `FiniteDimensional k Γ`.
  3. Close via `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite k _`.
- Final `haveI := hPI; haveI := hSep;` then close the surjectivity
  goal via `IsPurelyInseparable.surjective_algebraMap_of_isSeparable
  k Γ`.

**Net Lane 2 contribution**: signature inflations propagated; KDM
(BR.2)–(BR.4) scaffolded; constants substep 3 conjunction split
+ hSep branch closed. 0 strict-count sorry reduction (KDM stays
at 1, conjunction-split adds 1, hSep closure removes 1 → net 0),
but **the (b.1) hSep branch is now project-internally closed and
the residual is purely a function of Lane 1's (S3.sep.\*) closures**.

## Notable attempts + errors (selected from `attempts_raw.jsonl`)

| Code tried | Lean error / outcome | Insight |
|---|---|---|
| `[Algebra.IsStandardSmoothOfRelativeDimension k B]` (implicit `n`) | `typeclass instance problem is stuck: ... Lean will not try to resolve this typeclass instance problem because the first type argument ... was a metavariable` | Add `{n : ℕ}` as explicit binder; consumer must pass `(n := n)` to KDM. |
| `refine ⟨?_, ?_⟩` (top-level on conjunction goal — initially attempted before the smart-proof reduction) | `Invalid '⟨...⟩' notation: The expected type ∀ b, ∃ a, (algebraMap k Γ) a = b` (Function.Surjective shape) | Use `have ⟨hPI, hSep⟩ : IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ := by refine ⟨?_, ?_⟩; ...` to first prove the conjunction in a separate by-block, then consume via `haveI` for the surjectivity goal. |
| `let _basis := Module.Free.chooseBasis B (Ω[B⁄k])`; `simp [Derivation.coe_comp, hDb]` | one-line simp closes the coord-vanish (`∂_i b = (basis.coord i) (D b) = (basis.coord i) 0 = 0`) | `Derivation.coe_comp` unfolds `(f.compDer D) b = f (D b)` cleanly. |
| `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n` | extracts `Algebra.IsStandardSmooth k B` | The relative-dimension class is a `Prop`, not an instance — must dispatch through the named theorem. |
| `(CategoryTheory.Iso.commRingCatIsoToRingEquiv (Scheme.ΓSpecIso (CommRingCat.of k))).symm.finite` | `((Scheme.ΓSpecIso (.of k)).inv.hom).Finite` | The ring iso `Γ(Spec k) ≅ k` extracts to RingEquiv whose `.symm.finite` gives the inverse-direction finiteness. |
| `_hAppTopFinite.comp hiso` | `(α.hom).Finite` where `α = (ΓSpecIso).inv ≫ (appTop)` | `RingHom.Finite.comp` chains the two finiteness witnesses. |
| `RingHom.finite_algebraMap.mp hαFinite` | `Module.Finite k Γ` | Bridges `(algebraMap k Γ).Finite` to `Module.Finite k Γ`. |

## Key findings / patterns discovered

1. **First-class sub-claim decomposition as an iter-strategy unit**:
   the (S3.sep.1) / (S3.sep.2) / (S3.pi.1) / (S3.pi.2) decomposition
   strictly increases the named-sorry count (one wrapper sorry →
   four first-class sorries) but converts a single "smart proof
   gap" into four independently-targetable closures, each with
   named Mathlib bridges or explicit Stacks Tag anchors.
   Subsequent iters close each independently — the structural
   advance is the closure-target landscape, not the absolute count.

2. **KDM (BR.5) joint-kernel collapse is the genuine residual**:
   `Differential.ContainConstants A B` packages the property for a
   SINGLE derivation, but `ker ∂_1 ⊋ k` in
   `k[x_1, x_2]` — single-coord vanishing alone is insufficient.
   The JOINT kernel `⋂_i ker(∂_i) = range (algebraMap k B)` in
   char 0 + standard-smooth requires a coordinate induction
   argument on the smooth presentation (Stacks 07F4). This is
   genuine ~40–80 LOC project work, NOT a Mathlib-search miss.

3. **FiniteDimensional bridge via `Iso.commRingCatIsoToRingEquiv` +
   `RingEquiv.finite` + `RingHom.Finite.comp` + `RingHom.finite_algebraMap`**:
   the iter-149 hSep branch's bridge from `_hAppTopFinite` to
   `FiniteDimensional k Γ` is reusable for any scheme-side
   "appTop.hom finite ⇒ Γ finite-dim over k" propagation. The
   chain composes 4 Mathlib lemmas in a single algebraic step.
   Reusable iter-150+ for the hPI branch (which also needs
   `FiniteDimensional k Γ` for (S3.pi.2)).

4. **Path (b) sub-claims as Mathlib-PR candidates**:
   `(S3.sep.1)` (`Smooth ⇒ GeometricallyReduced` morphism-class
   instance) and `(S3.pi.1)` (Stacks 02KH H^0 row) are genuine
   Mathlib upstream gaps; the iter-150+ closure may legitimately
   produce upstream PR proposals.

## Blueprint markers updated (manual)

(None this review-phase. The blueprint-writer-rigiditykbar-iter149
landed the (S3.*) sub-claim promotion + (BR.1)–(BR.5) restructuring
in the plan phase. The `\leanok` on the (S3.\*) statement blocks
should remain — the declarations exist in Lean with their correct
signatures (sorry body is allowed at the statement-block level).
The `\leanok` on the (S3.\*) proof blocks at L1994 (S3.sep.1 proof),
L2036 (S3.pi.1 proof), etc.\ will be reconciled by the deterministic
`sync_leanok` pass since the bodies remain `sorry`.)

The blueprint-doctor report is empty (no orphan chapters, no broken
cross-references, no axioms). No manual marker action needed.

## Recommendations for next session

See `recommendations.md` for the priority-ordered action list.
Headlines: (1) close at least 2 of (S3.sep.2) / (S3.pi.2) /
(S3.sep.1) for the iter-150 escalation hook clearance; (2)
either (S3.pi.1) build OR H1Cotangent-vanishing reformulation as
the iter-150+ strategic decision per iter-149 plan Decision 2;
(3) hPI branch closure depends on (S3.pi.1) + (S3.pi.2) +
Smooth ⇒ IsReduced X_{\\bar k} base-change.

## Iter-150 escalation hook (carried verbatim from iter-149 plan)

> If iter-149 lane closes ≤1 of the four (S3.\*) sub-claims AND
> the KDM (p2) bridge body remains a structured `sorry`, iter-150
> MUST escalate via mid-iter mathlib-analogist in
> `cross-domain-inspiration` mode for the H1Cotangent-vanishing
> reformulation. The route-pivot conversation becomes mandatory.

**Status**: iter-149 closed **0 of 4 (S3.\*) sub-claims** AND
the KDM (p2) bridge body remains a structured `sorry`. **The
escalation hook FIRES.** Iter-150 plan agent MUST dispatch the
mid-iter `mathlib-analogist` in `cross-domain-inspiration` mode
for the H1Cotangent-vanishing reformulation, with the route-pivot
conversation becoming mandatory.

The iter-149 prover lane delivered substantial scaffolding
(structural decomposition + (BR.2)–(BR.4) KDM advance + hSep
branch closure), but in the strict sub-claim-closure metric the
hook is now triggered. The hSep branch closure is an
**intermediate consumer-side advance** that does not count
against the (S3.\*) closure metric in the hook.
