# Picard/TensorObjSubstrate/DualInverse.lean — iter-260

## Assigned task
Close `sliceDualTransport` (L184) → `dual_restrict_iso` naturality (L356) via the route-(1)
consumer of the now-green shared root (`restrictOverIso`/`unitOverIso` from
`SheafOverEquivalence.lean`), per the iter-260 directive. Armed reversing signal: "If
`restrictOverIso`/`unitOverIso` do NOT apply sectionwise in the expected form, leave a typed
sorry + report the EXACT failing step; do NOT switch to the route-(2) ~200-LOC sectionwise
fallback unilaterally."

## sliceDualTransport (L184)

### Attempt 1 — directive step 1: reduce the iso goal
- **Approach:** `refine LinearEquiv.toModuleIso ?_`.
- **Result:** RESOLVED (this step) — committed to code. The iso goal reduces cleanly to the
  `𝒪_Y(V)`-linear equivalence
  `(restr fV' M.val ⟶ restr fV' 𝟙_X) ≃ₗ[𝒪_Y(V)] (restr V (pushforward β M.val) ⟶ restr V 𝟙_Y)`,
  `fV' = f.opensFunctor.obj V.unop`.
- **Key finding (corrects the directive):** the `Module 𝒪_Y(V)` structure on the LHS DOES
  synthesize automatically here — NO `letI _ := Module.compHom … (β.app V)` is needed at this
  step (it comes through `internalHomObjModule`/`homModule` of the pushforward). The directive's
  worry on that point does not materialize.

### Attempt 2 — directive route (1): consume `restrictOverIso`/`unitOverIso`
- **Approach:** obtain the reduced `≃ₗ` from the shared-root consumer isos localized to `V`.
- **Result:** FAILED — **route (1) is STRUCTURALLY INSUFFICIENT** (this is the EXACT failing step
  the armed reversing signal asked to report; not tactic difficulty).
- **Exact failing step / reason:**
  - `restrictOverIso U M : (overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U` and
    `unitOverIso U : (overEquivalence U).functor.obj (unit _) ≅ unit _` are isomorphisms of
    **sheaf objects** (`SheafOfModules (X.ringCatSheaf.over U)`) of the modules `M`, `𝟙_`. They
    mention **nothing about `dual`/internal-hom**.
  - The reduced goal is a `≃ₗ` between two **presheaf internal-hom section modules over DIFFERENT
    slice categories** (`Over_X fV'` vs `Over_Y V`). Its entire content is that the dual
    (`internalHomPresheaf · 𝟙_`) **commutes** with the slice reindexing along `f.opensFunctor`.
  - Producing that commutation from the shared root would require `(overEquivalence U).functor`
    (a `SheafOfModules.pushforward`) to **preserve internal hom**, i.e. to be strong monoidal
    **closed**. No shared-root decl supplies this (verified by grep: `SheafOverEquivalence.lean`
    has only `overEquivalence`, `restrictOverIso`, `unitOverIso`, `chartOverIso`, `phiOver`,
    `psiOver`, `psiRestrict`, `overForgetNatIso`, continuity instances, two image-equality
    lemmas — **no dual/internalHom lemma anywhere**). The `MonoidalClosed (PresheafOfModules R₀)`
    structure it would need is the wall the project deliberately avoids
    (TensorObjSubstrate §2 `rem:scheme_modules_monoidal_off_path`; PresheafInternalHom.lean:538).
- **Conclusion:** the shared root closes the engine's `chartOverIso` (object-level `restrict ↦
  over`/`unit ↦ unit`) but it is the WRONG tool for `sliceDualTransport`, whose content is dual
  commutation, not module-object transport.

### Route (2) — the genuine close (NOT undertaken, per armed signal)
- Build the `≃ₗ` forward/inverse by hand: **leg A** = slice reindexing of dual sections across
  `f.opensFunctor` (`homLocalSection`-style `eqToHom`-conjugation along `image_preimage_of_le`,
  naturality `Subsingleton.elim`), **leg B** = `restrictScalarsRingIsoDualEquiv` along the ring
  iso `β.app V = (f.appIso V).inv`.
- **Important:** leg B does NOT type-apply standalone — `restrictScalarsRingIsoDualEquiv` acts on
  a FIXED carrier `N →ₗ[S] S`, but here the two sides have different over-category INDEXING, so
  leg A must run first. So leg B cannot even be wired as a standalone compiling helper this
  session; route (2) is a single ~150–250 LOC intricate build, not decomposable into independent
  compiling sub-pieces.
- Per the armed reversing signal I did NOT start the unilateral route-(2) build. Typed `sorry`
  retained at the reduced `≃ₗ` goal.

## dual_restrict_iso naturality (L356)
- The `isoMk` naturality square references `(sliceDualTransport f M V).hom` / `… W).hom`. With
  `sliceDualTransport` opaque (sorry), the square is an equation of concrete module morphisms that
  **depends on the concrete value** of `sliceDualTransport` — it is NOT a `Subsingleton` hom-type
  (checked the goal: `((pushforward β).obj M.val.dual).map g ≫ (restrictScalars …).map (…W).hom =
  (…V).hom ≫ (M.restrict f).val.dual.map g`). So it genuinely cannot be discharged until
  `sliceDualTransport`'s body is concrete. Transitively blocked on L184. Typed `sorry` retained.

## Import note
- The directive said to `import AlgebraicJacobian.Picard.SheafOverEquivalence`. I did NOT add it:
  route (1) being structurally insufficient, the shared-root decls are unusable here and the
  import would be dead weight (route (2) does not use the shared root either). Documented for the
  planner.

## Changes committed (code)
1. `sliceDualTransport` body: replaced the bare trailing `sorry` with the genuine reduction step
   `refine LinearEquiv.toModuleIso ?_` + `sorry` (exposes the precise remaining `≃ₗ` obligation in
   code; confirms automatic module-instance synthesis).
2. Updated the in-body comment block of `sliceDualTransport` with the full route-(1)
   structural-insufficiency diagnosis.
3. Fixed the stale STATUS NOTE inside `dual_restrict_iso` (directive's explicit fix task,
   aud259 major): it no longer claims route (1) is "gated on an in-flight shared root"; it now
   records that the root is green but route (1) is structurally insufficient, and that route (2)
   is the genuine close (awaiting planner sanction).

## Summary
- **sorry count: 2 → 2** (unchanged in count). Both now carry a genuine reduction step / precise
  structural diagnosis rather than a bare/aspirational `sorry`.
- **Closed:** none.
- **Still open:** `sliceDualTransport` (L184) — reduced one step (`LinearEquiv.toModuleIso`), then
  blocked: route (1) structurally insufficient (no dual-commutation in shared root; needs avoided
  monoidal-closed structure); route (2) forbidden unilaterally by the armed signal.
  `dual_restrict_iso` naturality (L356) — transitively blocked on `sliceDualTransport` being
  concrete.
- **Adjacent sorries:** none other in file (`dual_unit_iso`, `dual_isLocallyTrivial`,
  `homOfLocalCompat`, `presheafDualUnitIso`, `dualUnitIsoGen`, `unitDualSectionEquiv`,
  `homLocalSection`, `topSectionToHom` are all CLOSED; `dual_isLocallyTrivial` inherits the
  `dual_restrict_iso` residual axiomatically only).
- File compiles; only warnings are the 2 expected `sorry`s + pre-existing deprecations/long-lines
  in already-CLOSED decls (L408/410/752/756/758), none introduced by me.

## Why I stopped
**Partial progress + armed-signal-compliant stop.** Real code change: the directive's step-1
reduction (`refine LinearEquiv.toModuleIso ?_`) is now committed in `sliceDualTransport`'s body,
exposing the exact remaining `≃ₗ` goal in code and confirming the module instances synthesize
automatically (refuting the directive's `letI Module.compHom` worry). The substantive blocker is
unchanged: I determined — by inspection of the reduced goal and an exhaustive grep of the shared
root — that the directive's route (1) (consume `restrictOverIso`/`unitOverIso`) is **structurally
insufficient**, because those are sheaf-object isos of `restrict`/`unit` that say nothing about
`dual`; the reduced goal's content is dual/internal-hom commutation with slice reindexing, which
the shared root cannot supply without the deliberately-avoided `MonoidalClosed` structure. This is
exactly the situation the iter-260 armed reversing signal anticipated ("if route (1) does not
apply, leave a typed sorry + report the EXACT failing step; do NOT switch to route (2)
unilaterally"). I therefore did not start the ~150–250 LOC route-(2) build (which is also not
decomposable into independent compiling sub-pieces — leg B does not type-apply before leg A).

**Recommendation for the planner:** route (1) is dead for `sliceDualTransport`. Choose one:
  (a) **Sanction route (2)** — the direct sectionwise `sliceDualTransport` build (leg A
      `homLocalSection`-style reindexing across `f.opensFunctor` ∘ leg B
      `restrictScalarsRingIsoDualEquiv`). This is the realistic close; budget a dedicated multi-iter
      lane. It is self-contained in this file (no cross-lane race).
  (b) Add a new shared-root lemma "`overEquivalence` functor preserves internal hom / dual" — but
      this itself requires the monoidal-closed structure the project avoids, so it is strictly
      harder than (a). Not recommended.
