# Picard/TensorObjSubstrate/DualInverse.lean (iter-259)

## Summary

File compiles cleanly with the **same 2 typed sorries** it had at iter-258 entry:
- `sliceDualTransport` (L184) — the per-`V` slice transport `≃` of the `dual_restrict_iso` Step-4 residual.
- `dual_restrict_iso` (L327) — the `isoMk` naturality square, which is **strictly downstream** of
  `sliceDualTransport` (its `isoMk` family is `fun V => sliceDualTransport f M V`, so the naturality
  cannot be discharged while that family is opaque; confirmed `isoMk`'s default `cat_disch` cannot
  reduce an opaque family).

No sorry was closed this iter. **Both routes to close `sliceDualTransport` are currently gated**
(detail below). I verified the exact residual goal, recorded the LHS-module-instance requirement,
updated the stale guidance comment, and kept the file green. This is a HELD-but-dispatched file
(PROGRESS.md / task_pending.md both mark Lane TS-inv HELD this iter); the analysis below is the
actionable hand-off.

## Verified residual goal (live this iter)

After `refine LinearEquiv.toModuleIso ?_` at the `sliceDualTransport` body, the goal is the
`𝒪_Y(V)`-linear equivalence
```
((pushforward₀ f.opensFunctor X.ringCatSheaf.obj).obj (dual M.val)).obj V
  ≃ₗ[ Y.ringCatSheaf.obj.obj V ]
(internalHomPresheaf ((pushforward β).obj M.val) 𝟙_Y).obj V
```
i.e. `(restr fV' M.val ⟶ restr fV' 𝟙_X) ≃ₗ[𝒪_Y(V)] (restr V (pushforward β M.val) ⟶ restr V 𝟙_Y)`
with `fV' = f.opensFunctor.obj V.unop`. This is **exactly the per-open localization of the shared
root `Scheme.Modules.overEquivalence`** (the iter-258 probe finding, now re-confirmed against the
current code). The iter-230 `overSliceSheafEquiv`/fixed-value-cat path is retired (cannot carry the
varying ring `𝒪_Y(V)`).

**Key instance gotcha (recorded for next prover):** `LinearEquiv.toModuleIso` does **not**
auto-synthesize the LHS `Module ↑(Y.ringCatSheaf.obj.obj V)` structure on
`((pushforward₀ …).obj (dual M.val)).obj V` — `lean_multi_attempt` reports
`failed to synthesize Module ↑(Y.ring V) ↑(((pushforward₀ …).obj M.val.dual).obj V)`. It must be set
up via `letI _ : Module … := Module.compHom … (β.app V)`, exactly as `restrictScalarsRingIsoDualEquiv`
(`PresheafInternalHom.lean:234`) does with its `_iM`/`_iMS` `letI`s.

## Why neither route was closed this iter

### Route (1) — consumer one-liner (the strategy's chosen close) — GATED on in-flight shared root
The residual `≃ₗ` is the per-`V` localization of `overEquivalence.functor = pushforward (phiOver U)`.
Closing it cleanly consumes the shared root's consumer isos `restrictOverIso` / `unitOverIso`
(`SheafOverEquivalence.lean`), localized to `V`, plus a bridge from the open immersion `f` to
`U := f.opensRange` (`f ≅ U.ι`).
- **`restrictOverIso` (L235) and `unitOverIso` (L276) are NOT yet green** — they are the iter-259
  PRIMARY lane, being proved in parallel. I observed `SheafOverEquivalence.lean` was modified at
  19:38 today (after this file at 17:47) and currently has 4 `sorry`-occurrences — i.e. the parallel
  prover is **actively editing it mid-iter**.
- Adding `import AlgebraicJacobian.Picard.SheafOverEquivalence` now therefore re-introduces the
  **iter-257 cross-lane compile race** that PROGRESS.md explicitly holds this file to avoid, and the
  consumed isos aren't closed anyway (the result would be sorry-transitive, not a genuine close).
- **Correct timing:** close NEXT iter as a one-liner once the shared root is fully green + stable.

### Route (2) — direct sectionwise build (documented fallback) — deferred churn, infeasible at budget
Build `sliceDualTransport`'s forward map à la `homLocalSection` (`eqToHom`-conjugation across
`f.opensFunctor` along `image_preimage_of_le`, naturality by `Subsingleton.elim`) composed with
`restrictScalarsRingIsoDualEquiv` (codomain-unit ring swap via `(f.appIso V).inv`). This is a
~150–250 LOC, instance-delicate (`Module.compHom`/`letI`) `PresheafOfModules.Hom` build that the
iter-258 plan **deliberately deferred** as multi-iter churn in favour of route (1). It is the only
self-contained route, but is not responsibly completable in one session and is likely throwaway once
route (1) lands.

## Changes made
- Replaced the stale `⚠ WARM-CONTEXT WARNING (pc251)` comment block (L287–315, aud258-flagged: it
  advised the superseded `overSliceSheafEquiv`/"genuine new build" path) with an accurate iter-259
  STATUS NOTE recording the verified residual goal, the LHS-module-instance gotcha, and the two
  gated close-routes. (Comment-only; no proof change; file stays green.)

## sliceDualTransport (L184)
### Attempt (diagnostic)
- **Approach:** verify the reduced `≃ₗ` and probe `LinearEquiv.toModuleIso { toFun := …, … }` +
  `PresheafOfModules.Hom.mk'` skeleton.
- **Result:** PARTIAL (diagnostic only). Residual `≃ₗ` confirmed; LHS `Module 𝒪_Y(V)` instance must
  be provided via `Module.compHom (β.app V)` (not auto-synthesized).
- **Next step:** Route (1) one-liner next iter once `restrictOverIso`+`unitOverIso` are green; else
  Route (2) direct build (forward map = `homLocalSection`-style `eqToHom`-conjugation across
  `f.opensFunctor` ∘ `restrictScalarsRingIsoDualEquiv`).
- **Dead end:** do NOT route through `overSliceSheafEquiv` (fixed value cat, cannot carry varying
  `𝒪_Y(V)`); do NOT add `import …SheafOverEquivalence` while that lane is mid-edit (live race).

## dual_restrict_iso (L327)
### Attempt
- **Approach:** check whether the `isoMk` naturality square is independently closable.
- **Result:** FAILED — it is `isoMk (fun V => sliceDualTransport f M V) ?_`; `isoMk`'s default
  `cat_disch` naturality cannot reduce the opaque `sliceDualTransport` family. Strictly downstream of
  `sliceDualTransport`; closes for free (`by cat_disch` / `Subsingleton.elim`) once that family is
  concrete.

## Blueprint markers
No declaration newly closed → no `\leanok` change requested. `Picard_TensorObjSubstrate.tex`
(`lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`) remains sorry-transitive as before.

## Recommendation to plan agent
Keep Lane TS-inv HELD for one more iter and close `sliceDualTransport` as the **route-(1) consumer
one-liner** immediately after `SheafOverEquivalence.{restrictOverIso,unitOverIso}` land green and
stable (then add the import; bridge `f ≅ (f.opensRange).ι`). The residual goal + instance recipe are
now recorded in-file (L287-style STATUS NOTE) and above. Avoid the route-(2) direct build unless the
shared root stalls.
