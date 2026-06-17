# Session 44 (iter-044) review summary

## Metadata
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded: `CechHigherDirectImage.lean:679`
  (frozen P5b), `CechAcyclic.lean:110` (dead `affine`). (`CechAcyclic.lean:18` is the word "sorry" in
  prose, not a tactic.) Prover file `QcohTildeSections.lean` is **0-sorry**.
- **Build:** GREEN. Independently re-verified by review — fresh `lake env lean …
  QcohTildeSections.lean` EXIT 0; all 5 new decls `#print axioms` = `{propext, Classical.choice,
  Quot.sound}` (not LSP-only — fresh `lake env lean`, per the kernel-soundness/stale-olean trap).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+5 axiom-clean decls**, 0 new sorries.
- **Targets:** named target `tile_scalar_compat` (Sub-lemma B residual ring identity) — SOLVED;
  4 supporting lemmas — SOLVED; `tile_section_localization` (keystone leaf) — deferred (honest stop,
  no sorry papered).

## Headline — the keystone's last tile ingredient (Sub-lemma B) is CLOSED, axiom-clean
The iter-043 reduction (Sub-lemma B → "one structure-sheaf ring identity, ~30–50 LOC") was realized.
The prover closed `tile_scalar_compat` via **route (A) (Γ-Spec naturality)** and built four reusable
supporting lemmas. The keystone route has now landed axiom-clean decls every prover iter
(040:+4, 041:+3, 042:+1, 043:+2, 044:+5). The CHURNING the progress-critic flagged at iter-043 is
resolved on contact: the planner's corrective (blueprint expansion before re-dispatch) was the right
call — the route converged this iter rather than rotating helpers.

## What was tried (grounded in attempts_raw.jsonl)

### `tile_scalar_compat` — SOLVED (the iter-044 named target)
- **Reduction step (validated, not assumed):** `rw [modulesSpecToSheaf_smul_eq F]; rw [show … from
  modulesRestrictBasicOpen_smul_eq]; congr 1` — `lean_goal` confirmed this leaves **exactly one**
  `case e_a` ring-identity goal (the prover validated the in-file "PROVEN tactic prefix" comment with
  `lean_goal` before relying on it — the progress-critic enforcement the planner baked in).
- **Failed route — `globalSectionsIso.hom` form (attempt 2):** `simp only [Scheme.Opens.ι_appIso,
  StructureSheaf.globalSectionsIso_hom]` then trying to `rw` the restriction map repeatedly failed
  with *"rewrite failed: Did not find an occurrence of the pattern `(Spec R).presheaf.map (homOfLE
  …).op`"* and *"motive is not type correct"*. **Root cause (crucial finding):** the codomain of
  `globalSectionsIso.hom` is in `Spec.structureSheaf`-functor form, which is **defeq-but-not-syntactic**
  to `(Spec R).presheaf`, breaking `Category.assoc`/`rw` composability with `appTop`.
- **Winning route — `ΓSpecIso.inv` form (attempts 3–4):** state/prove everything in `Scheme.ΓSpecIso.inv`
  form. The `globalSectionsIso ↔ ΓSpecIso.inv` swap is `CommRingCat.hom_ext rfl`. Three reusable bricks:
  - `appTop_appIso_inv_eq_res {X Y} (f) [IsOpenImmersion f]`: `f.appTop ≫ (f.appIso ⊤).inv =
    Y.presheaf.map (homOfLE (f ''ᵁ ⊤ ≤ ⊤)).op` — via `Iso.comp_inv_eq`, `appIso_hom`,
    `Scheme.Hom.naturality`, thin-cat subsingleton. (An earlier scratch attempt using
    `congrArg X.presheaf.map (Subsingleton.elim …)` gave a type mismatch — wrong shape.)
  - `key_morph (g)`: ΓSpec naturality of `specAwayToSpec g = Spec.map (algebraMap R R_g)`, via
    `Scheme.ΓSpecIso_inv_naturality` + `specAwayToSpec_eq` + `reassoc_of%` + `appTop_appIso_inv_eq_res`.
  - `tile_appIso_comp (g)`: `comp_appIso` fold of the two tile section isos, via `Scheme.Hom.comp_appIso`
    + `Scheme.Opens.ι_appIso` (= refl) + `simp [Iso.trans_inv, eqToHom_map, eqToHom_op]`.
  - `tile_section_ring_identity (g)`: assembled morphism identity = `key_morph` + `tile_appIso_comp` +
    `← Functor.map_comp; congr 1`.
  - Final: `congrArg (·.hom r) tile_section_ring_identity` + `simp [CommRingCat.comp_apply]` +
    `convert … using 2`. Needed `set_option maxHeartbeats 1000000` for the `convert`-step defeq check on
    the tile section carriers.

### `tile_section_localization` — deferred (honest stop, no sorry papered)
- The prover scouted the assembly and **kernel-confirmed** the genuine obstruction: the bundled section
  carriers `Γ_{R_g}(⊤, tile) : ModuleCat R_g` and `Γ_R(D(g), F) : ModuleCat R` are **not the same
  bundled type** (scratch `example` gave *"Type mismatch … ModuleCat R but is expected … ModuleCat
  (Localization.Away g)"*). The iter-043 rfl bridges live at the **underlying-type / `F.val`** level, not
  the bundled `modulesSpecToSheaf.obj` level. So the base-ring descent must be applied at the
  underlying-type level (`letI` `Module R` + `IsScalarTower R R_g`, transport opens by `eqToHom`).
  This is engineering (~100–150 LOC), not a math wall. Correctly NOT papered with a sorry.

## Review subagent findings (full reports linked; act-items in recommendations.md)
- **lean-auditor `iter044`** (0 critical / 2 major / 7 minor): all 5 new decls kernel-sound; the
  `congr 1`/`convert using 2` closures are NOT the spurious-rfl trap (goals are genuine thin-Opens-cat
  subsingleton morphism equalities). **2 major:** deprecated `Sheaf.val` appears in the *type signatures*
  (not just proof bodies) of `modulesSpecToSheaf_smul_eq` (L732) and `modulesRestrictBasicOpen_smul_eq`
  (L741) — a Mathlib `Sheaf.val → ObjectProperty.obj` migration will break these load-bearing helpers.
  Report: `.archon/task_results/lean-auditor-iter044.md`.
- **lean-vs-blueprint-checker `qts`** (0 must-fix Lean / 5 major blueprint-side): **the `\lean{}` pin
  the prover requested is REJECTED** — `tile_scalar_compat` is the scalar equality at `V=⊤`, NOT the
  full natural `R_g`-linear iso `lem:tile_section_comparison` asserts; pinning would over-claim. Needs a
  dedicated block. Also: `tile_scalar_compat` covers `V=⊤` only — `tile_section_localization` will also
  need scalar compatibility at `V=D(f̄)`. Report: `.archon/task_results/lean-vs-blueprint-checker-qts.md`.

## Key findings / patterns
- **`ΓSpecIso.inv` over `globalSectionsIso.hom` for structure-sheaf section composability.** When a goal
  composes a global-sections ring iso with `(Spec R).presheaf.map`/`appTop`, use the `Scheme.ΓSpecIso.inv`
  form; `globalSectionsIso.hom`'s codomain is defeq-but-not-syntactic to `(Spec R).presheaf`, so
  `rw`/`assoc` fail to fire. The two are interchangeable by `CommRingCat.hom_ext rfl`.
- **Validate "PROVEN prefix" comments with `lean_goal` before building on them** (progress-critic
  enforcement) — the prover did, confirming the reduction leaves exactly one ring-identity goal.
- **Bundled-vs-underlying carrier distinction (project memory `keystone-tile-reconciliation-not-rfl`):**
  re-confirmed at the kernel — scalar/carrier defeq holds at the `F.val`/underlying-type level, NOT at
  the bundled `ModuleCat R_g` vs `ModuleCat R` level. The next assembly must work underlying-type-level.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_comparison`: added `% NOTE (review
  iter-044)` recording that the residual ring identity is CLOSED in Lean as `tile_scalar_compat` (+ the
  4 route-(A) helpers), that the `\lean{tile_scalar_compat}` pin is REJECTED (statement mismatch: scalar
  equality at `V=⊤` vs full natural iso), and that the planner should author a dedicated block for
  `tile_scalar_compat` + the helpers and tighten the under-specified sketch. No `\leanok` touched (owned
  by sync; +4 this iter). No `\mathlibok` (all project theorems). No `\lean{}` rename applied (the pin
  was rejected — left as coverage debt for the planner to blueprint as new blocks).

## Low-severity notes
- In-file block comment (`QcohTildeSections.lean` ~L894–934): "PARTIAL this iter" heading is now stale
  (`tile_scalar_compat` is closed); the tactic-prefix description omits the terminal `convert … using 2`
  step. Cosmetic — the prover owns the file; flagged for the next prover touch.
