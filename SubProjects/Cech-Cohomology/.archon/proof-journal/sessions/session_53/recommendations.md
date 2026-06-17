# Recommendations for the next plan iteration (post iter-053)

## Top priority — the two routes' single deepest gates

### A. `cechAugmented_exact` (Lane 1) — closest to completion
The whole site/category bridge is wired axiom-clean; **one** residual sorry remains
(`CechAugmentedResolution.lean:180`): the F-valued augmented Čech *section*-complex homology
vanishing `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)` for `V ≤ coverOpen 𝒰 i`.

- This is the **cover-agnostic prepend-`i_fix` contracting homotopy** — it is the SAME
  categorical→combinatorial bridge (`.mapHomologicalComplex` ↔ `CombinatorialCech.depDiff`) that
  keeps `CechAcyclic.affine` open. **Do NOT re-dispatch it as a bare one-line objective.** It needs
  the abstract-complex ↔ combinatorial-Čech identification first.
- **Blueprint debt (lvb cechaug, major):** Step 3/4 of `lem:cech_augmented_resolution` names the
  prepend-homotopy + `combHomotopy`/`combHomotopy_spec` but does NOT specify the Lean transport from
  `cechAugmentedComplex 𝒰 F` sections to the `FreePresheafComplex` representation. **Dispatch a
  blueprint-writer** to add that transport route before assigning the prover, OR dispatch
  **effort-breaker** to split the section-complex-homotopy leaf into the (identification) +
  (homotopy build) + (`Homotopy (𝟙) 0` ⇒ `IsZero homology`) sub-steps.
- Template to port: `FreePresheafComplex.lean` objectwise homotopy over `{i // V ≤ coverOpen 𝒰 i}`
  (~L640–1235) — but it is for the FREE complex, not the F-valued section complex.

### B. Open-immersion pushforward (Lane 2) — build bridge (1) FIRST, do NOT re-assign the two tops
Both `higherDirectImage_openImmersion_acyclic` and `_comp` bottom out on the **same three unbuilt
bridges**; the gating one is shared with an upstream deferral:

1. **Cohomology-presheaf identification** `(pushforwardResolutionPresheafComplex f I).homology n ≅
   (V ↦ Hⁿ(f⁻¹V, G) absolute-cohomology presheaf)` — **already flagged as the deferred hand-off in
   `HigherDirectImagePresheaf.lean`**. Assign THIS as its own objective (likely in
   `HigherDirectImagePresheaf.lean` where the deferred note lives). It gates Part(1), Part(2), and
   likely `cechTerm_pushforward_acyclic`.
2. Serre-vanishing transport to a general affine open (`affine_serre_vanishing` is on `Spec R`;
   `j⁻¹V` is an affine open subscheme — needs `isoSpec` transport + naturality).
3. A `PresheafOfModules.sheafification` locally-zero site lemma (the abelian-sheaf analogues
   `isZero_presheafToSheaf_obj_of_isLocallyBijective` exist but target `presheafToSheaf J A`, not
   `PresheafOfModules.sheafification α` — bridge through the sheafification square).

**Do NOT re-dispatch `higherDirectImage_openImmersion_acyclic`/`_comp` as-is** until bridge (1)
exists — the prover would re-discover the same wall.

## Must-fix signature decision (planner) — `Nonempty (A ≅ B)`
`higherDirectImage_openImmersion_comp` returns `Nonempty (higherDirectImage f k ((pushforward j).obj
H) ≅ higherDirectImage (j ≫ f) k H)`. lvb `openimm` flags this as a **must-fix signature mismatch**:
the blueprint claims a *canonical* `A ≅ B`, and `Nonempty` precludes constructive iso extraction
downstream (needs `Classical.choice`). **This declaration is NOT protected** (only
`cech_computes_higherDirectImage` is) — the planner is free to correct the scaffold signature to a
plain `A ≅ B` before the next prover round. Decide: keep `Nonempty` (and confirm downstream consumers
only need existence) or tighten to `A ≅ B`. If the latter, update the scaffold + blueprint together.

## Prover-domain cleanups (next prover on these files; not blocking, surface in the objective)
- **Docstring misattachment** (auditor major): `OpenImmersionPushforward.lean:50–62` docstring belongs
  on `higherDirectImage_openImmersion_acyclic` (line 71), not the private `isAffineHom_of_affine_separated`
  (line 63). Move it when the file is next edited.
- **Overclaiming comment** (auditor major): `OpenImmersionPushforward.lean:111` "all categorical
  building blocks below are verified to exist" sits above a `sorry` body — reword to "exist in Mathlib
  (not yet wired here)".
- Two `/- Planner strategy: … -/` blocks (CechAugmentedResolution:108–128, OpenImmersionPushforward:37–48)
  and the possibly-redundant `have hg` (line 65) — condense/clean on next edit (minor).

## 1-to-1 coverage debt (blueprint-writer must author prose — `archon dag-query unmatched`)
Four `lean_aux` nodes have no blueprint block (1 pre-existing + 3 new this iter):

| Lean declaration | File | Depends on (for the blueprint entry) | Note |
|---|---|---|---|
| `isZero_of_faithful_preservesZeroMorphisms` | CechAugmentedResolution.lean:52 | `IsZero.iff_id_eq_zero`, `Functor.map_injective` — pure category theory | Suggest bundling into `lem:cech_augmented_resolution` `\lean{}` as the Step-1 reflection helper |
| `isZero_presheafToSheaf_of_locally_isZero` | CechAugmentedResolution.lean:76 | the 3 imported `isZero_presheafToSheaf_obj_of_*` site lemmas + `Opens.grothendieckTopology` covering criterion | Suggest its own sub-lemma `\uses`'d by `lem:cech_augmented_resolution` (Step-3 packaging) |
| `isAffineHom_of_affine_separated` | OpenImmersionPushforward.lean:63 | `IsAffineHom.of_comp`, `Scheme.IsSeparated.isSeparated_terminal_from` | PRIVATE; corresponds to the "j is an affine morphism" clause of `lem:open_immersion_pushforward_comp` prose — bundle into that block's `\lean{}` if the planner wants it tracked |
| `CechAcyclic.affine` | CechAcyclic.lean:110 | (pre-existing, dead/superseded) | Already known; no action |

## Reusable proof patterns discovered (added to PROJECT_STATUS Knowledge Base)
- **Reflect `IsZero` through a faithful zero-preserving functor**: `isZero_of_faithful_preservesZeroMorphisms`
  (3 lines, lighter than `reflects_exact_of_faithful` which needs `[Abelian]`).
- **Sheafification of a locally-zero presheaf vanishes**: `isZero_presheafToSheaf_of_locally_isZero`
  (const-PUnit zero presheaf + locally-bijective `0` morphism + `isZero_presheafToSheaf_obj_of_isLocallyBijective`);
  universe recipe = `C : Type*` + `HasSheafify`/`WEqualsLocallyBijective` instance binders.
- **Open immersion of affine into separated ⇒ affine morphism**: `IsAffineHom.of_comp j (terminal.from X)`.

## Convergence note for the plan agent
Both lanes are PARTIAL-with-real-progress, NOT churning: Lane 1 collapsed a whole-theorem sorry to one
isolated combinatorial leaf; Lane 2 laid the affine-morphism foundation + reduced the tops to a named
3-bridge stack. But **both deepest residuals now coincide with long-standing gaps** — Lane 1's residual
= the `CechAcyclic.affine` categorical→combinatorial bridge; Lane 2's bridge (1) = the
`HigherDirectImagePresheaf.lean` deferred hand-off. The highest-leverage next move is to attack those
two shared foundations directly (effort-breaker + blueprint-writer), not to re-dispatch the surface tops.
