# iter-066 review

## Overall progress this iter
- **Project real sorry: 9 → 6** (net −3, 0 papered). Real holes: CSI `cechSection_complex_iso`
  (1492 `coreIso`, 1504 `hcompat`) + `cechSection_contractible` (1585); CechAugmentedResolution 229;
  CechHigherDirectImage frozen P5b (780); CechAcyclic dead `affine` (110).
- **Build: GREEN** — re-verified first-hand: `lake build` of both prover modules EXIT 0 (8331 jobs).
  `lean_verify higherDirectImage_openImmersion_comp` = `{propext, Classical.choice, Quot.sound}` (no `sorryAx`).
- **Lanes: 2 (`prove`).** OpenImm = FULL closure (`_comp`, 4 sub-leaves); CSI = partial (framework + 2 leaves).
- **dag-query:** gaps = 0; unmatched = 4 (3 new CSI helpers `mapHC_augment_iso`/`augmentCochainIso`/
  `map_augment_cond` + dead `affine`). sync_leanok iter=66 (sha `46c28a4`, +16/−0). blueprint-doctor: clean.

## Headline — the open-immersion route is FULLY DONE
With iter-065's `_acyclic`, the STRETCH `higherDirectImage_openImmersion_comp` (`R^k f_*(j_*H) ≅ R^k(j≫f)_*H`)
closes the entire open-immersion pushforward arc. The decisive unlock was `hacyc` (`j_* Iⁿ` is `f_*`-acyclic),
which the iter-066 plan had already corrected off the FLAWED Serre-vanishing-on-`U∩f⁻¹V` route (that open is not
affine) onto the adjoint route — and the prover found the concrete incantation:
`unfold Scheme.Modules.restrictFunctor; exact inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint`
(**plain `infer_instance` FAILS**) → mono-preserving → `Injective.injective_of_adjoint (restrictAdjunction j)`
→ `Functor.IsRightAcyclic.ofInjective`. `eRes`/`hexact`/`transport` are the mechanical cosyzygy / `_acyclic`-reuse
/ `pushforwardComp`-defeq legs. The blueprint correction made last iter paid off cleanly — no churn.

## CSI Stub 5 — augmentation framework built, reduced to 2 leaves (not yet closed)
The prover built three sorry-free reusable helpers (`mapHC_augment_iso`, `augmentCochainIso`, `map_augment_cond`)
for promoting degreewise data to augmented-complex isos, then peeled the augmentation in `cechSection_complex_iso`
(outer body sorry-free, `eY := Iso.refl _` since the `restrictScalars(𝟙·)⋙toPresheaf` adapter is transparent).
Residual: `coreIso` (non-aug degreewise iso) + `hcompat` (degree-0 compat). Stub 6 untouched. This is genuine
forward motion (1 opaque Stub-5 sorry → reusable framework + 2 tractable leaves) — read it as CONVERGING, dispatch
the 2 leaves + Stub 6 next iter.

## Soundness — confirmed three ways, no papering
- **Review first-hand:** `lake build` EXIT 0; `_comp` axiom-clean; CSI sorry warnings exactly at the 3 honest leaves.
- **lean-auditor iter066** (`task_results/lean-auditor-iter066.md`): 0 must-fix / 2 major / 2 minor. Both OpenImm
  closures GENUINE (`hacyc` adjoint route real; no thin-cat `Subsingleton.elim`/`congr` kernel-trap — the trap did
  NOT fire). CSI helpers clean; the 3 open CSI sorries honestly typed. The 2 majors are STALE `.lean` comments
  (877–896 + 956–966) that call closed cases "remaining"/"handed off" and misdescribe `hacyc` as Serre-vanishing.
- **lvb-openimm iter066**: 0 must-fix; `_comp` faithfully follows the rewritten adjoint blueprint; zero stale
  Serre-vanishing prose. 2 major = (i) sync-leanok artifact (private names in `\lean{}` block `\leanok` on the
  closed `_acyclic`/`jshriek_transport_along_iso`); (ii) 2 unused `\uses{}` in `_comp`.
- **lvb-csi iter066**: 0 must-fix; tagged decls match; Stub 6 sketch ADEQUATE; `hcompat` sketch THIN; coverage
  debt on the 3 new helpers.

## Markers I changed (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:open_immersion_pushforward_acyclic`: added `% NOTE:` — sorry-free
  since iter-065 but lacks `\leanok` because its `\lean{}` lists the **private** `isAffineHom_of_affine_separated`
  (name-mangled, unresolvable by `sync_leanok`). Fix = un-`private` or drop from `\lean{}`.
- `Cohomology_CechHigherDirectImage.tex`, `lem:jshriek_transport_along_iso`: added `% NOTE:` — same root cause
  (private `sectionsCorep`/`sectionsCorepPushforward`), `\leanok` missing ~6 iters.
- No `\mathlibok` (all new decls are project proofs). No stale `\notready` found. Did NOT touch `\leanok`.

## Why the missing `\leanok` is NOT laundering
Investigated per the "don't paper over" rule: the two affected decls compile, are sorry-free, and `_comp`
(which transitively uses `_acyclic`) is kernel-clean via `lean_verify`. The markers are blocked purely by
`private` names in the `\lean{}` lists that `sync_leanok` cannot resolve (jshriek has missed ~6 syncs — strong
corroboration). Surfaced as a recommendation (un-`private`); I did not hand-add `\leanok` (sync's domain).

## Subagent dispatches
- lean-auditor (both files), lean-vs-blueprint-checker ×2 (OpenImm, CSI). All returned 0 must-fix. Reports in
  `task_results/`. No skips this phase (both prover files received edits).
