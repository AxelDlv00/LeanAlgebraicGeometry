# Recommendations for iter-178 plan

## CRITICAL — must-fix-this-iter

1. **RESTORE BUILD (must run first).** Thread
   `[Scheme.IsRegularInCodimensionOne C.left]` into
   `AlgebraicJacobian/RiemannRoch/OCofP.lean` namespace variable
   block (L152-156, right after `[IsLocallyNoetherian C.left]`).
   1 LOC. Verify `lake build AlgebraicJacobian` returns exit 0 with
   no errors. **Dispatch as Lane 1 with PRIORITY** (other lanes
   can self-verify against a green build only after this lands).

2. **Lean-auditor MUST-FIX-this-iter (6 items).** Full report at
   `task_results/lean-auditor-iter177.md`. Required corrections:
   - **`GmScaling.lean` L212/L308** — both temp axioms have
     suspicious bodies and propagate through Cor 1.5. Action:
     iter-178 plan-phase dispatch a **mathlib-analogist** consult
     on the cover-vs-`Proj.awayι` syntactic mismatch (the
     iter-177 plan reversal trigger; not yet fired). This is the
     route to retire BOTH axioms.
   - **`Picard/RelativeSpec.lean` L172/L192** — placeholder bodies
     (`RelativeSpec := X`, `structureMorphism := 𝟙 X`). Action:
     dispatch mathlib-analogist on `Scheme.QcohAlgebra → relative
     Spec` type encoding BEFORE any further body lanes on
     RelativeSpec/QuotScheme. Per the iter-177 plan's standing
     deferral; iter-178 is the iter to fire this consult.
   - **`Picard/LineBundlePullback.lean` L119** — `OnProduct :
     Type (u+1) := sorry`. Action: scope a body-fill lane on
     LineBundle.OnProduct iter-178+ (currently blocking Lane 5
     `PicSharp.addCommGroup` body close).
   - **`RationalCurveIso.lean` L330** — strengthen Pin 3 hypothesis
     from `Nonempty (functionField ≅ functionField)` (Type-Iso)
     to `Nonempty (functionField ≃+* functionField)` or
     `CommRingCat.Iso`. 1-LOC signature fix.

## HIGH — recommended this iter

3. **Pre-dispatch coordination on signature changes.** Two
   consecutive iters have lost productivity to parallel-lane
   signature-change races (iter-176 Lane D ↔ Lane K; iter-177
   Lane WD ↔ Lane 1). Suggested mitigation in iter-178 plan:
   if any prover lane is allowed to ADD an instance binder to a
   shared lemma, the plan must (a) name the signature change
   explicitly in the lane directive, AND (b) name every downstream
   consumer file the change affects, AND (c) either serialize the
   dependent lane OR pre-thread the new instance into the
   consumer's variable block before dispatch.

4. **Mathlib-analogist consult on cover-vs-`Proj.awayι` mismatch**
   (iter-177 reversal trigger). The iter-177 plan committed: "if
   iter-177 returns even with the temporary axiom in place, treat
   the cover-vs-`Proj.awayι` mismatch as a genuine Mathlib gap and
   dispatch a fresh mathlib-analogist consult on the relative
   position of `Scheme.Cover.openCover.f i` vs `Proj.awayι 𝒜
   (X i) _ _`". The axiom IS in place; the trigger fires. Persists
   to `analogies/<slug>.md`.

5. **Mathlib-analogist consult on Scheme.QcohAlgebra → relative
   Spec type encoding** (per progress-critic route177 + iter-177
   standing deferral). Without this consult, any body lane on
   `RelativeSpec`-family (including the QuotScheme
   `canonicalBaseChangeMap_isIso` follow-up) discharges against
   placeholder bodies — the iter-176 laundering pattern. Persists
   to `analogies/<slug>.md`.

## MEDIUM — defer if budget tight

6. **Refine `SymmetricPower C (g : ℕ)` signature** to discriminate
   on `g` (currently `_g : ℕ` discards the parameter). Substantive
   non-tautological types require the carrier to depend on `g`.
   Either `Sym^g C := Quotient (S_g \\ Cⁿ)` placeholder OR a typed
   sorry `{ X : Over (Spec (.of kbar)) // ... g-discrimination
   property ... }`. 5-10 LOC; cleanups for downstream consumers.

7. **Rename or strengthen `Scheme.IsRegularInCodimensionOne`**.
   Lean-auditor: the class as-written carries `Ring.KrullDimLE 1`
   on stalks at prime divisors, which is weaker than "regular in
   codim 1" (which would require regular local rings). Either
   rename to `LocallyKrullDimLEOneAtPrimeDivisors` (or similar)
   OR add a stronger `out : ∀ Y, IsRegularLocalRing
   (X.presheaf.stalk Y.point)` field. 1-LOC class rename across
   ~4 use sites + bridge instance.

8. **Body lane on `Scheme.localRing_dvr_of_codim_one`**
   (`Albanese/CodimOneExtension.lean` L195) — Stacks 0BBI,
   "normal scheme stalk at codim-1 point is DVR". Mathlib-adjacent
   (Mathlib has Krull-dim-1 + normal → DVR for rings; needs the
   scheme-side specialization). Estimated 30-50 LOC. NEXT TARGET on
   Route 4.

9. **`canonicalBaseChangeMap_isIso` body** (Lane 4 follow-up,
   `Picard/QuotScheme.lean` L437). Recipe in body comment:
   affine-local reduction + `Module.Flat.isBaseChange` (Stacks
   00H8). Gated on relative-Spec type-encoding consult landing
   first (recommendation 5).

## LOW — informational notes

- `lean-vs-blueprint-checker` was skipped for all 8 prover-touched
  files this iter; iter-178 should re-fire on the 4 substantive
  lanes (GmScaling, WeilDivisor, OCofP, QuotScheme) once the
  build is restored. Skip rationale recorded in `summary.md` §
  Subagent skips.
- `sync_leanok` added 24 `\leanok` markers iter-177 against
  `AbelianVarietyRigidity / Albanese_AlbaneseUP /
  Albanese_CodimOneExtension / RiemannRoch_RationalCurveIso`. The
  AVR markers transitively depend on the GmScaling temp axioms;
  the markers are honest (each decl elaborates cleanly), but
  consumers of these chapter `\leanok`s should be aware they
  transitively consume `gmScalingP1_chart_data_temp` and
  `gmScalingP1_collapse_at_zero_temp`.

## Targets the plan agent should NOT re-assign

- **`gmScalingP1_chart_PLB_eq` body**, **`gmScalingP1_chart_agreement`
  body**, **`gmScalingP1_collapse_at_zero` body** — iter-176 HARD
  STOP rule LOCKED these off-critical-path until the
  cover-vs-`Proj.awayι` mismatch is settled via the queued
  mathlib-analogist consult (recommendation 4). Do not open a 7th
  helper round.

- **`Scheme.WeilDivisor.principal_degree_zero`** — STRETCH; needs
  two sub-builds (finite-morphism-from-non-constant-rational +
  degree multiplicativity under finite pullback) not in project or
  Mathlib. Defer to iter-179+ when one of those is funded.

- **`PicSharp.addCommGroup` body** — gated on A.1.b
  `LineBundle.OnProduct` carrier. Do not re-fire until A.1.b
  ships.

## Reusable proof patterns discovered iter-177

(See PROJECT_STATUS.md Knowledge Base for canonical wording.)

1. **`Finsupp.ofSupportFinite` + opaque finite-support helper** is
   the cleanest body for principal-divisor / similar
   "free-abelian-on-prime-divisor" constructions where the
   finite-support condition reduces to a Mathlib-pending lemma —
   package the finiteness as a `private theorem` and consume it.
2. **`CategoryTheory.mateEquiv` is the Mathlib-aligned source of
   canonical Beck-Chevalley nat. transformations** for
   pullback-pushforward base-change squares.
3. **Helper-with-sorry as honest scaffold** for deep claims
   (Stacks 02KH-class) when the main definition is axiom-clean
   and the helper isolates the substantive content. Distinguishes
   from placeholder-body laundering by the litmus: does the named
   helper's TYPE carry the substantive content? (Yes here; main
   body unfolds against substantive helper.)

## Loop infrastructure observations

- The blueprint-doctor correctly flagged both new project axioms
  (file `.archon/logs/iter-177/blueprint-doctor.md` lists exactly
  the two `gmScalingP1_*_temp` declarations). No new orphan
  chapters or broken `\uses{}`/`\ref{}` finds this iter.
- `sync_leanok` ran cleanly at 16:14:17Z post-prover-phase,
  adding 24 markers across 4 chapters, removing 0. Aligned with
  the loop's deterministic discipline.
