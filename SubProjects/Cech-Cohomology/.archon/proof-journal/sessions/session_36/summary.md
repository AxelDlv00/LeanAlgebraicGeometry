# Session 36 (iter-036) — review summary

## Metadata
- **Iteration:** 036 — single prover lane: `QcohTildeSections.lean` (01I8 Route B, keystone bricks).
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead,
  `CechHigherDirectImage.lean:~679` frozen P5b). The prover file is 0-sorry.
- **Build:** GREEN. `lake env lean AlgebraicJacobian/Cohomology/QcohTildeSections.lean` EXIT 0,
  diagnostics empty; all 3 new decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Decls added:** +3 axiom-clean (all in `QcohTildeSections.lean`); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 4** (1 pre-existing dead `CechAcyclic.affine` +
  3 new Route-B bricks with no blueprint block).

## Headline — Route B local-model bricks landed; the globally-presented keystone case is COMPLETE
The single prover lane delivered the three load-bearing engines of the 01I8 Route B keystone, each
stating the concrete section-restriction `Γ(Spec R, F) → Γ(D(f), F)` is
`IsLocalizedModule (Submonoid.powers f)`:

1. **`tilde_section_isLocalizedModule (M : ModuleCat R) (f : R)`** — the pure `tilde` case
   (`F = M^~`). Transports Mathlib's `tilde.toOpen` localization instance (Tilde.lean:115, which
   localizes `M` itself) onto the *section group* `Γ(⊤, M^~)` via the global-sections iso
   `eTop := (asIso (tilde.toOpen M ⊤)).toLinearEquiv` and `toOpen_res`, finishing with
   `IsLocalizedModule.of_linearEquiv_right`.
2. **`section_isLocalizedModule_of_isIso_fromTildeΓ (F) [IsIso F.fromTildeΓ] (f)`** — the per-piece
   engine. `α := qcoh_iso_tilde_sections F : F ≅ tilde (Γ F)`, pushed to the presheaf level through
   `TopCat.Sheaf.forget`, component isos via `NatIso.isIso_app_of_isIso`, then `β.naturality`
   conjugates brick (1) by the two component linear-equivs.
3. **`section_isLocalizedModule_of_presentation (F) (P : F.Presentation) (f)`** — the keystone for
   any **globally**-presented `F`: a 2-line composition `isIso_fromTildeΓ_of_presentation` (Mathlib)
   + lemma (2). This is exactly the situation on each affine cover piece.

The named keystone `qcoh_section_isLocalizedModule` (unconditional `[IsQuasicoherent F]`) was
correctly left ABSENT (no `sorry`, mathlib-build invariant) — it is genuinely blocked, not forced.

## Why the keystone stopped (clean, named obstruction)
Going from the globally-presented case to the unconditional quasi-coherent case requires, on each
piece `D(g_j)` of a finite standard cover: identifying `Γ(D(g_j), F)` with `(F.over (D g_j)).Γ`,
giving `F.over (D g_j)` a global presentation (restrict the `QuasicoherentData` presentation along
the slice inclusion), and base-changing `D(g_j) ≅ Spec R_{g_j}` so the section-restrictions become
`R_{g_j}`-module localizations. **None of this `.over`→affine bridge exists in Mathlib** — it is
several hundred LOC of missing infrastructure, not a tactic block. The descent primitive
(`isLocalizedModule_of_span_cover`, DONE iter-032) and the cover refinement
(`exists_finite_basicOpen_subcover`, DONE iter-031) are already in place; only the per-piece transfer
geometry is missing.

## Tactic notes / patterns discovered (for next prover)
- **`TopCat.Sheaf` is an `InducedCategory`** → a Sheaf morphism has NO `.val` field. To reach the
  underlying presheaf morphism of `modulesSpecToSheaf.map α.hom`, go through
  `(TopCat.Sheaf.forget (ModuleCat R) (Spec R)).map …`. (`(…).val` fails with
  `InducedCategory.Hom.val does not exist`.)
- **`inferInstance` fails for the `D(f)` component iso** of a forgotten natural iso; use
  `CategoryTheory.NatIso.isIso_app_of_isIso β _` explicitly.
- **Categorical `inv`/`Iso.eq_inv_comp`/`IsIso.inv_comp_eq` rewrites repeatedly fail** to match
  identical-looking targets (coercion/instance mismatch on `inv` and on `ModuleCat.Hom.hom (…) (e.symm x)`).
  The robust route is to drop to the **linear-map level** with explicit `LinearEquiv`s
  (`asIso(...).toLinearEquiv`), prove the map equality pointwise (`conv_lhs => rw [← htop]`), and
  finish with `IsLocalizedModule.of_linearEquiv(_right)`.
- **`IsLocalizedModule.of_linearEquiv_right` / `of_linearEquiv`** take the submonoid `S` and the base
  map `f'` as **explicit** arguments (not just the equivalence `e`).
- `set … with h` definitions of `eTop/eDf/φ` stay **defeq-transparent**, so `exact hx` closes the
  naturality step without any unfolding; `change _ = eDf.symm (φ x)` over `show` to coax the goal.

## Review-subagent findings (full reports linked; details in recommendations.md)
- **lean-auditor `iter036`** (0 critical / 2 major / 2 minor): all 3 lemmas genuine + axiom-clean; the
  two majors are `.lean` docstring inaccuracies — a stale "two declarations" section header (now
  three) and a self-contradictory "keystone" overclaim on the special-case lemma. Both are
  comment-only, not correctness defects. Report:
  `task_results/lean-auditor-iter036.md`.
- **lean-vs-blueprint-checker `qcohtilde`** (4 major, 0 must-fix): the 3 new bricks are faithful to
  the keystone's blueprint sketch but lack dedicated blueprint blocks (coverage debt); the keystone
  proof sketch is under-specified — it hides the `.over`→affine bridge behind "fix j and localize at
  g_j" and its `\uses` should cite `lem:modules_restrict_basicOpen`. Report:
  `task_results/lean-vs-blueprint-checker-qcohtilde.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_section_isLocalizedModule`: added a
  `% NOTE (iter-036): …` recording that the three local-model bricks are now formalized + axiom-clean,
  and that the unconditional case's remaining gap is the `.over`→affine base-change bridge
  (the `\uses` / sketch should be extended to cite `lem:modules_restrict_basicOpen` — planner action).
- No `\leanok` touched (owned by `sync_leanok`; iter=36 ran, +4/−1). No `\mathlibok` added (the 3 new
  decls are project theorems, not Mathlib re-exports). No `\lean{}` rename (the bricks have no
  blueprint blocks yet; nothing to correct). No stale `\notready` present in the chapter.

## Notes (LOW)
- ~14 docstring lines in `QcohTildeSections.lean` exceed the 100-char lint limit (cosmetic).
- 5 unused `set … with h` witness names in `section_isLocalizedModule_of_isIso_fromTildeΓ` (harmless).
- Blueprint doctor: clean (no orphan chapters, no broken `\ref`/`\uses`, no new `axiom`).
