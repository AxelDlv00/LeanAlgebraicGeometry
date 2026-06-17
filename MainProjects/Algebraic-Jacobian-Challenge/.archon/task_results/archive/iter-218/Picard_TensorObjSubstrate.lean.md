# Picard/TensorObjSubstrate.lean — iter-218

## PRIMARY: `exists_tensorObj_inverse` (was L1375, now L1390)

### Attempt 1 — blueprint dual route
- **Approach:** `lem:tensorobj_inverse_invertible`: set `Linv := ℋom_{𝒪_X}(L, 𝒪_X)`,
  show it locally trivial, exhibit the contraction `L ⊗_X Linv → 𝒪_X` and prove it a
  global iso via the CLOSED `tensorObj_restrict_iso` + `tensorObj_unit_iso`, mirroring
  `tensorObj_isLocallyTrivial` (L1349).
- **Result:** INFRASTRUCTURE MISSING (INCOMPLETE gate fired). Blocked at step 1 — the
  dual object `Linv` cannot even be **named**, so no tactic state advances.
- **Exact blocker (verified against on-disk Mathlib `b80f227`):**
  1. No `MonoidalClosed (PresheafOfModules R)` instance — `loogle`
     `MonoidalClosed (PresheafOfModules ?R)` → no results (matches the file's §2
     "verified-absent `MonoidalClosed` wall" note).
  2. No `MonoidalClosed (SheafOfModules R)` / no `SheafOfModules`-level internal-hom,
     dual, or evaluation object. `CategoryTheory.sheafHom` lands in `Sheaf J (Type …)`,
     which carries NO `𝒪_X`-module structure, so it is not the internal hom of
     `𝒪_X`-modules.
  3. No monoidal escape hatch: `MonoidalCategory (X.Modules)` is deliberately NOT built
     for the varying structure sheaf (`rem:scheme_modules_monoidal_off_path`, memory
     `commring-pic-is-skeleton-route`), so dualizable/rigid-object API is unavailable.
  4. No object-level descent for `SheafOfModules` (build a global object from a cover +
     transition cocycle); Mathlib has section-gluing (`existsUnique_gluing`) and "iso is
     local" (`MorphismProperty.isomorphisms.IsLocalAtTarget` for subcanonical `J`,
     `Sheaf.isLocallyBijective_iff_isIso`) but NOT object assembly.
- **Informal agent:** called (`--provider auto`, MOONSHOT key set) → HTTP 401 Invalid
  Authentication. No external sketch obtained; blocker analysis is Mathlib-source-derived.
- **Missing primitive (mathlib-analogist target):** an internal-hom/dual + evaluation for
  `SheafOfModules R` (preferably presheaf-level then sheafify, mirroring `tensorObj`):
  `dual M : X.Modules` and `eval : tensorObj M (dual M) ⟶ SheafOfModules.unit X.ringCatSheaf`.
  Full decomposition + the available downstream steps written to
  `informal/exists_tensorObj_inverse.md`.
- **Gate compliance:** per the progress-critic ts218 PRE-CAUTION + PROGRESS.md INCOMPLETE
  gate, did NOT push a `dual`-shaped helper-sorry forward (iter-214 d.1 anti-pattern).
  Left the typed `sorry` with a detailed in-code blocker comment; updated the stale
  "iter-202 scaffold" docstring to the iter-218 blocker analysis.

## SECONDARY (bonus −1): re-route `tensorObj_assoc_iso` + delete whiskering apparatus

- **Status of `tensorObj_assoc_iso` (L1152→L1150):** ALREADY a complete (no-sorry) body via
  the ROUTE-(d) whiskering composite. It transitively depends on the L600 sorry
  `isLocallyInjective_whiskerLeft_of_W` through `W_whiskerLeft_of_W`/`W_whiskerRight_of_W`
  (the live `_of_W` chain). So the −1 = eliminate the L600 sorry.
- **Two paths to the −1, BOTH Mathlib-blocked:**
  - **(a) Close L600 directly.** Needs the stalkwise route: (d.1-bridge) site-level `J.W` ⇔
    topological stalkwise-iso on `Opens X`, and (d.2) stalk-⊗ commutation
    `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` over the varying ring. d.2 is Mathlib-absent (the
    largest piece); the progress-critic explicitly warned against pushing this
    (iter-214 d.1 anti-pattern). A stalk-free route was considered ("g ∈ J.W ⇒ locally an
    iso ⇒ F ◁ g locally iso") but local bijectivity is per-section-covering-sieve, not a
    uniform cover where `g` restricts to a presheaf iso, so it does not avoid stalks; the
    categorical `J.W.IsMonoidal` route is circular (it IS what L600 would supply).
  - **(b) Re-route assoc onto `tensorObj_restrict_iso` + delete the apparatus.** Needs to
    build a GLOBAL iso by gluing local isos over a cover (the "glue via Hom-is-a-sheaf"
    step) — i.e. morphism-level descent for `SheafOfModules`. The local isos
    (`tensorObj_restrict_iso` twice + presheaf associator) do NOT auto-assemble into a
    global morphism; that needs the sheaf-Hom descent construction, which is heavy/absent
    at this level. The current whiskering proof bridges the inner sheafification
    (`a(a(M⊗N).val ⊗ P.val) ≅ a((M⊗N)⊗P.val)`) precisely via the whiskered unit — the
    `restrict_iso` route cannot reproduce that bridge without gluing.
- **Decision:** did NOT attempt a broken partial re-route (it would leave non-compiling
  gluing scaffolding); reported the precise blocker instead.
- **Dead-code audit (for the eventual deletion package):** `lean_references` confirms
  `isLocallyInjective_whiskerLeft_of_flat` (L444) is referenced only by `W_whiskerLeft_of_flat`
  (L521→523), and `stalkLinearEquivOfIsIso` (L799) has **zero** references. The `_of_flat`
  chain (`isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`,
  `W_whiskerRight_of_flat`) and the stalk lemmas (`stalkLinearMap`, `_germ`,
  `_bijective_of_isIso`, `stalkLinearEquivOfIsIso`) are effectively dead. **NOT deleted**
  this iter: deleting them removes NO sorry (the L600 sorry lives in the LIVE `_of_W`
  chain used by `tensorObj_assoc_iso`), so deletion gives zero sorry-progress and only
  risks the build; it belongs in the same package as the assoc re-route once (b) is
  unblocked.

## Ride-along cleanup (done; build kept green)
- Fixed false "typed `sorry`" docstrings on `tensorObj` (L981) and `tensorObj_functoriality`
  (L997) — both are fully defined now.
- Updated the stale "iter-202 scaffold" tail of the `exists_tensorObj_inverse` docstring to
  the iter-218 INCOMPLETE-gate blocker analysis.
- **Did NOT** drop `@[implicit_reducible]` on `addCommGroup_via_tensorObj` (directive item):
  it is a `def` of class type `AddCommGroup`, so dropping the attribute triggers the
  "class type must be marked `@[reducible]`/`@[implicit_reducible]`" linter and adds a
  warning. Retained it (with a note) to keep the build clean; recorded the reason in-code.
- **Did NOT** touch the 17 deprecated `Sheaf.val` sites: these are defeq-load-bearing for
  the assoc-iso carrier bridge (`Sheaf.val X.ringCatSheaf` is only `rfl`-defeq, not
  syntactically equal, to `X.presheaf ⋙ forget₂ …`), so a mechanical replacement risks
  breaking `rfl`/`exact` defeq closes. Left as-is (deprecation warnings only).

## Summary
- **Sorry count: 3 → 3** (unchanged). Open: `isLocallyInjective_whiskerLeft_of_W` (L600),
  `exists_tensorObj_inverse` (L1390), `addCommGroup_via_tensorObj` (L1440, out of scope this iter).
- **Closed:** none.
- **Still open + why:** `exists_tensorObj_inverse` — Mathlib-absent internal-hom/dual for
  `SheafOfModules` (blocked at step 1, cannot name `Linv`). L600 — Mathlib-absent stalk d.2 /
  morphism-descent. Both reported precisely; `exists_tensorObj_inverse` blocker → `informal/`.
- **Adjacent sorries:** examined both other sorries (L600, L1440); both blocked on the same
  missing-descent/stalk infrastructure family, not closable this iter.

## Why I stopped
- **Infrastructure missing** (PRIMARY `exists_tensorObj_inverse`): the dual object
  `ℋom_{𝒪_X}(L,𝒪_X)` and its evaluation have NO `SheafOfModules`-level construction at
  `b80f227` (no `MonoidalClosed` on `PresheafOfModules`/`SheafOfModules`, no internal hom,
  no object-level descent; no `MonoidalCategory (X.Modules)` by design). The construction is
  blocked at its first step, so no tactic progress (not even `refine ⟨Linv, …⟩`) is possible
  without pushing a forbidden `dual`-shaped helper-sorry. Informal agent attempted, returned
  401. Exact missing primitive + decomposition in `informal/exists_tensorObj_inverse.md`.
  This is precisely the mathlib-analogist trigger the progress-critic ts218 PRE-CAUTION
  scheduled for before iter-220.
- **Code progress this iter:** none on sorry count (honest). Changes are docstring
  corrections (cosmetic) + the new `informal/` blocker report + a precise dead-code/blocker
  audit for the SECONDARY package. No working proof was within reach without the named
  absent infrastructure.
