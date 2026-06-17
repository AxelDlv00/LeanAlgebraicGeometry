# Iter-049 objectives (detail)

## Lane 1 — `AffineSerreVanishing.lean` [mathlib-build] — CRITICAL PATH
Build NEW decls (do not yet exist; file header hands them off):
- `affine_cech_vanishing_qcoh` (`lem:affine_cech_vanishing_qcoh`, ~bp line 6045) — 02KG seed.
  Deps DONE: `qcoh_iso_tilde_sections` (unconditional iter-048), `sectionCech_affine_vanishing` (P3),
  `affineCoverSystem`/`affine_faces_mem`/`affine_surj_of_vanishing`/`affine_injective_acyclic` (in-file).
  Route: `F≅~M` (M=Γ(X,F)) → P3 standard-cover tilde vanishing applies to `~M` → transport along the
  natural section-Čech-complex iso.
- `affine_serre_vanishing` (`lem:affine_serre_vanishing`, ~bp line 3206) — 02KG top.
  Instantiate `cech_eq_cohomology_of_basis` (01EO, DONE) at `affineCoverSystem`; cond (3) = the seed; V=U.
  Carries `[EnoughInjectives X.Modules]` explicit hyp (connector deferred to P5b — do NOT discharge here).
Same lane, seed → top.

## Lane 2 — `CechHigherDirectImage.lean` [mathlib-build] — P5a, INDEPENDENT
Build NEW decl `cechAugmented_exact` (`lem:cech_augmented_resolution`, ~bp line 6785). Do NOT touch protected
`cech_computes_higherDirectImage` or line-679 sorry.
- Statement: the augmented Čech complex of qcoh `F` (from `coverCechNerveOverAug`/`CechNerve`, augmented by F)
  is exact = a resolution in QCoh(X).
- Proof (sketch rewritten iter-049 → stalk-at-prime): exactness of a sheaf complex is stalk-local; on affine
  `U=Spec A`, `F|_U≅~M`; localize at prime `𝔭`; some `f_i∉𝔭` is a unit ⟹ contracting homotopy = P3
  `sectionCech_affine_vanishing` / `exact_of_isLocalized_span`. Holds at every prime ⟹ exact on X.
- Likely need a "sheaf-of-modules complex exact iff stalkwise exact" criterion — build project-side if absent.
- Deep (effort ~1054); a precise decomposition handoff is an acceptable, valuable outcome.

## Dropped frontier nodes (not lanes)
- `cech_free_eval_prepend_homotopy` — no `\lean{}` pin by design (math node in DONE FreePresheafComplex.lean).
- `tilde_restrict_basicOpen` — dormant Route-P (off-limits).

## Gate / subagent record
- blueprint-reviewer `iter049`: HARD GATE clears for all 3 targets, 0 must-fix.
- blueprint-writer `cechaug` + blueprint-clean `cechaug`: Lane-2 sketch aligned to stalk-at-prime + purified.
- progress-critic, strategy-critic: skipped (rationale in plan.md `## Subagent skips`).
