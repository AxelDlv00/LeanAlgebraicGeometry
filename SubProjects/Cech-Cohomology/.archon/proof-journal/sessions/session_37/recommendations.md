# Recommendations for the next plan iteration (iter-038)

## Closest-to-completion / prioritize next
1. **B3 `overBasicOpenIsoRestrict` (`lem:restrict_over_compat`)** — the single load-bearing bridge of
   Route B, now half-discharged (site equivalence continuous both ways). Build the prover-supplied
   **B3a/B3b/B3c** decomposition:
   - **B3a** module equivalence `(↥D(g)).Modules ≌ SheafOfModules ((Spec R).ringCatSheaf.over D(g))` via
     `pushforwardPushforwardEquivalence (overEquivalence (specBasicOpen g)) φ ψ H₁ H₂`, with `φ/ψ` built
     from `(specBasicOpen g).ι.appIso` (reuse the `Scheme.Modules.restrictFunctor` ring-map recipe,
     `Modules/Sheaf.lean:319`); object map `M.restrict (specBasicOpen g).ι ↦ M.over (specBasicOpen g)`.
   - **B3b** transport `↥D(g) → Spec R_g` via `restrictFunctor (basicOpenIsoSpecAway g).inv` (restriction
     along an ISO ⇒ equivalence of `.Modules`), landing on `modulesRestrictBasicOpen g M`.
   - **B3c** assemble `overBasicOpenIsoRestrict := (B3a obj iso) ≪≫ (B3b transport)`.
   - **Reuse the B2 trap list** verbatim (IsContinuous-literal / `Presentation.ofIsIso.{u,u,u}` /
     explicit `preimageIso` / `backward.isDefEq.respectTransparency false`).
2. **B4 `presentationModulesRestrictBasicOpen`** — mechanical once B3 lands:
   `(presentationOverBasicOpen M U P g hg).ofIsIso (overBasicOpenIsoRestrict …).hom`, with the
   `Presentation.ofIsIso.{u,u,u}` universe pin.
3. **Keystone assembly `qcoh_section_isLocalizedModule`** — once B1 (done) + B2 (done) + B3 + B4 are all
   present and `QcohRestrictBasicOpen` is imported into `QcohTildeSections`, the keystone is the B0–B6
   composition. PROGRESS currently forbids that import "yet" — the planner should lift the ban once B3/B4
   land.

## Blueprint-writer actions BEFORE the next prover lane (HARD GATE inputs)
- **B3 sketch is under-specified** (lvb-qrbo, major): the chapter describes the bridge mathematically but
  lacks the B3a/B3b/B3c decomposition via `(specBasicOpen g).ι.appIso`. Since B3 is the sole gate for B4
  and the keystone, dispatch a blueprint-writer to add the decomposition to `lem:restrict_over_compat`
  before the B3 prover lane.
- **Infra block for the 4 `overEquivalence` continuity decls** (lvb-qrbo + auditor, coverage debt):
  `Opens.overEquivalence_functor_coverPreserving`, `_inverse_coverPreserving`,
  `_functor_isContinuous`, `_inverse_isContinuous` have NO blueprint block. They are PROJECT theorems
  (genuine `CoverPreserving`/`IsContinuous` proofs closing a Mathlib TODO), so they need a real
  blueprint infra block, NOT `\mathlibok`. Thread the two `isContinuous` instances into B3's `\uses`.
- **B2 `\uses` incomplete** (lvb-qrbo, major): `lem:presentation_over_basicOpen`'s proof block cites only
  `lem:presentation_map_mathlib`; the Lean proof materially uses `pushforwardPushforwardEquivalence` and
  `Presentation.ofIsIso`. Add Mathlib anchors (or `\uses`) for both.

## Coverage debt (planner: add 1-to-1 blueprint entries) — `archon dag-query unmatched` = 6
- `AlgebraicGeometry.Opens.overEquivalence_functor_coverPreserving` — proof uses
  `Opens.overEquivalence`, `Opens.grothendieckTopology`, `GrothendieckTopology.mem_over_iff`.
- `AlgebraicGeometry.Opens.overEquivalence_inverse_coverPreserving` — same, inverse direction.
- `AlgebraicGeometry.Opens.overEquivalence_functor_isContinuous` (instance) — uses functor
  `coverPreserving` + `Functor.IsCoverDense.isContinuous` + auto cover-dense/locally-full/faithful.
- `AlgebraicGeometry.Opens.overEquivalence_inverse_isContinuous` (instance) — same, inverse.
- `AlgebraicGeometry.coversTop_iSup_eq_top` (private, QcohTildeSections) — `CoversTop` on opens ⇒
  `⨆ = ⊤`; proof uses `Opens.grothendieckTopology` sieve unfolding + `Sieve.ofObjects`. Bundle into
  `lem:qcoh_finite_presentation_cover`'s `\lean{...}` list per the "private is NOT exempt" convention.
- `AlgebraicGeometry.CechAcyclic.affine` — pre-existing dead node (sorry, frozen-file reference). Carried
  since iter-031; no in-loop fix (referenced by a protected file). Leave as documented debt.

## Investigate — `\leanok` sync gap (lvb-qts, major)
- `isLocalizedModule_of_span_cover` (P1b, iter-032, proven + axiom-clean) still lacks its **proof**
  `\leanok`. lvb-qts hypothesizes `sync_leanok` cannot resolve the 7 PRIVATE helper names bundled into
  its `\lean{...}` list and bails on the whole block. Planner: verify, and if confirmed, either trim the
  private names from that `\lean{...}` list (and instead cover them via a sibling block / accept them as
  documented unmatched) or flag the sync-script limitation to the user. This is NOT a correctness issue —
  the Lean is green and axiom-clean — only a marker-bookkeeping gap.

## Comment-only cleanups (refactor subagent, low priority)
- `QcohRestrictBasicOpen.lean:31` — stale docstring: claims `CompatiblePreserving` makes the
  equivalence's `IsContinuous` automatic. The real driver is `IsLocallyFull`+`IsLocallyFaithful`
  (auditor, via LSP hover). Fix the prose.
- `QcohRestrictBasicOpen.lean:~126` — add a companion comment to
  `set_option backward.isDefEq.respectTransparency false` on `presentationOverBasicOpen` explaining the
  `e.functor.obj (M.over W.left) =?= (M.over U).over W` defeq it bridges (auditor).

## Do NOT
- Do NOT re-dispatch a prover at the keystone `qcoh_section_isLocalizedModule` before B3+B4 land and the
  import ban is lifted — it is genuinely blocked on the B3 ring-sheaf compatibility datum, not a tactic.
- Do NOT mark the 4 `overEquivalence` decls `\mathlibok` — they are project proofs, not re-exports.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- `pushforwardPushforwardEquivalence` (Over.iteratedSliceEquiv) presentation-transport recipe + its 5
  elaboration traps (B2 — reuse for B3/B4).
- `Functor.IsCoverDense.isContinuous` (3 explicit args `J K G`) on a `CoverPreserving` witness, with the
  equivalence auto-deriving `IsCoverDense`/`IsLocallyFull`/`IsLocallyFaithful` — the recipe for closing
  site-equivalence continuity TODOs.
- Existential over `QuasicoherentData` must pin `.{u,u,u,u}`; use dot-notation `[hF : F.IsQuasicoherent]`
  to keep the module universe `u`.
