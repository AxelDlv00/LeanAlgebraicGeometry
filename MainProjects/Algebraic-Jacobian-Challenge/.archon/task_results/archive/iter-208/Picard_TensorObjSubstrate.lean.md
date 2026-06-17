# Picard/TensorObjSubstrate.lean — iter-208 Lane TS (Route A)

## tensorObj_restrict_iso (now L330)

### Attempt 1 — Route A audit + one real reduction step
- **Approach:** Follow the Route-A recipe (`analogies/tsroute208.md`): keep the two
  existing reduction steps (`restrictFunctorIsoPullback`, `sheafificationCompPullback`)
  and discharge the presheaf residual via the "sectionwise unfolding of
  `PresheafOfModules.pullback φ`".
- **Result:** PARTIAL. Added a **third genuine reduction step** (verified via
  `lean_goal`/`lean_multi_attempt`, compiles GREEN): strip the OUTER sheafification with
  `(PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).mapIso ?_`. Both sides of the
  goal are `sheafification.obj _`, so the goal reduces to the precise presheaf-level iso
  ```
  (PresheafOfModules.pullback φ.hom).obj (M.val ⊗ₚ N.val)
    ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val
  ```
  (resulting goal verified to contain no sheafification).
- **KEY FINDING — the recipe is INCORRECT.** The residual is NOT a "~30–60 LOC sectionwise
  unfolding of `pullback`". `PresheafOfModules.pullback φ.hom` is the OPAQUE abstract left
  adjoint `(pushforward φ.hom).leftAdjoint` (`Presheaf/Pullback.lean:44`) — no sectionwise
  formula. The recipe conflates the opaque `pullback` with the CONCRETE
  `restrict`/`pushforward` (`restrict_obj` is `rfl` because `M.restrict f =
  restrictFunctor f = SheafOfModules.pushforward β`, whose `.val =
  (PresheafOfModules.pushforward β.hom).obj M.val`, NOT a pullback). The kaehler precedent
  (`kaehler-...presheafpullback` Decision 5) hit the same opacity and EXCISED its
  unfolding helper.
- **Genuine route (documented in code + `informal/tensorObj_restrict_iso.md`):** TWO
  project-side ingredients, BOTH absent from Mathlib:
  - **H1 (linchpin):** presheaf-level `pushforward β.hom ≅ pullback φ.hom` via
    `Adjunction.leftAdjointUniq` from a presheaf-level `pushforward β.hom ⊣ pushforward φ.hom`
    (the presheaf analogue of `SheafOfModules.pushforwardPushforwardAdj`,
    `Sheaf/PushforwardContinuous.lean:226`). Needs presheaf-level `pushforwardNatTrans`
    + `pushforwardCongr` (only SHEAF versions exist). ~100–150 LOC.
  - **H2:** strong-monoidal comparison `(pushforward β.hom).obj (A ⊗ₚ B) ≅ (pushforward β.hom).obj A ⊗ₚ (pushforward β.hom).obj B`.
    Since `pushforward = pushforward₀ ⋙ restrictScalars` and `pushforward₀OfCommRingCat`
    is already `Monoidal`, this reduces to upgrading the file's lax
    `restrictScalarsLaxMonoidal` to STRONG (for a NatIso `α`) via
    `Functor.Monoidal.ofLaxMonoidal`. `IsIso ε` is easy; `IsIso μ` bottoms out in the
    absent Mathlib lemma "`ModuleCat.restrictScalars` along a ring iso is strong monoidal"
    (`extendScalars` is `Monoidal`, `restrictScalars` only `LaxMonoidal`). ~60–100 LOC.
  - Closure: `(pullback φ.hom)(M.val⊗ₚN.val) ≅[H1.symm] (pushforward β.hom)(M.val⊗ₚN.val)
    ≅[H2] (pushforward β.hom M.val) ⊗ₚ (pushforward β.hom N.val) =defeq (M.restrict f).val ⊗ₚ (N.restrict f).val`.
- **Dead ends (do NOT retry):** abstract mate-δ via `(pullback φ).Monoidal`; "sectionwise
  unfold the opaque pullback"; adding `IsLocallyTrivial` hyps.

## exists_tensorObj_inverse (L438) / addCommGroup_via_tensorObj (L478)
- **Result:** UNCHANGED — both blocked downstream on `tensorObj_restrict_iso`
  (cascade). Not attemptable until the blocker lands.

## Informal agent
- Unavailable this iter. The only key present (`MOONSHOT_API_KEY`) is a "Kimi For Coding"
  subscription key, rejected by the chat-completions API (403 `access_terminated_error`
  on `api.kimi.com/coding`; 401 on `api.moonshot.cn`) — usable only through coding-agent
  front-ends. Documented per protocol.

## Summary
- **Sorry count: 3 → 3** (no sorry closed). Sorries: `tensorObj_restrict_iso` (L330),
  `exists_tensorObj_inverse` (L438), `addCommGroup_via_tensorObj` (L478).
- **Code progress:** added one VERIFIED reduction step to `tensorObj_restrict_iso`
  (`sheafification.mapIso`), advancing the goal from a sheaf-level iso to the precise
  presheaf-level residual. File compiles GREEN (only pre-existing deprecation/lint
  warnings + 3 sorry warnings; zero errors, zero axioms).
- Did NOT close adjacent sorries — both are strictly downstream of the blocker.

## Why I stopped
**Partial progress + Infrastructure missing.**
- *Real code progress:* one new compiling reduction step in `tensorObj_restrict_iso`
  (strip outer sheafification via `mapIso`), leaving a strictly cleaner presheaf-level
  residual. NOT cosmetic — it is a genuine proof step verified by `lean_goal`.
- *Infrastructure missing (the residual):* closing the presheaf residual is a
  ~200–300 LOC `mathlib-build`-scale task needing 4 absent Mathlib ingredients:
  (1) presheaf `PresheafOfModules.pushforwardNatTrans`, (2) presheaf
  `PresheafOfModules.pushforwardCongr`, (3) presheaf-level `pushforwardPushforwardAdj`
  (⟹ H1 bridge), (4) strong-monoidal `ModuleCat.restrictScalars` along a ring iso
  (⟹ H2 bottom). I attempted the strong-monoidal upgrade route concretely (traced
  `pushforward = pushforward₀ ⋙ restrictScalars`, found `Functor.Monoidal.ofLaxMonoidal`,
  pinpointed the exact bottom gap) but did not add it as code: it bottoms out in (4),
  it is unwired without H1, and getting the presheaf iso-criterion + instance plumbing
  to compile is itself multi-iteration — adding it risked breaking GREEN for no closed
  sorry. The honest precise decomposition is in `informal/tensorObj_restrict_iso.md`.
- *Recommendation to planner:* this is NOT closable in `prove` mode. Re-route Lane TS to
  a `mathlib-build` lane targeting ingredients (1)–(4) in order (they are independently
  useful and the bottom one, (4), is a self-contained ~30–50 LOC algebra lemma worth
  building first). The Route-A "30–60 LOC" estimate is wrong by ~5× and conflates the
  opaque `pullback` with the concrete `pushforward`.
