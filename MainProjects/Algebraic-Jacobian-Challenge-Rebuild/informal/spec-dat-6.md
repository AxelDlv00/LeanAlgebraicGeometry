# DAT-6 spec — the slice trick + Zariski-sheaf packaging (ROUTE DECIDED)

*Written 2026-07-16 (Fable prover-architect, Wave-4 DATUM campaign). Binding worksheet:
`informal/w4-datum-worksheet.md` §1.2 site gap 1, §4 DAT-glue row, §5 item 7 (the
route choice explicitly deferred here). Gate: DAT-2 LANDED
(`Picard/Pic0ZariskiSheaf.lean`, ledger 9cabeaea2, root 8755 jobs). Probe performed
against the pinned mathlib checkout (`.lake-packages/mathlib`, v4.31.0), all claims
below verified by reading the cited `file:line` this pass. No Lean written before this
spec's commit.*

## §0 DECISION: Route A (the slice trick), with the over-topology EXCISED

**Route A is taken, in a sharper form than the worksheet's §1.2.1 pin**: the probe
shows the two feared costs of Route A — the over-topology sieve calculus
(`Sieve.overEquiv`/`mem_over_iff`) and the missing over-topology→topological-space
sheaf reduction (the `BigZariski.lean:22` TODO) — are **not needed at all**. We never
state a sheaf condition on the slice *site*. DAT-2 deliberately delivered the slice
sheaf property in explicit topological-cover form (`LocalData` +
`existsUnique_glue_of_le_cover` + `ext_of_le_cover` + the S-lemma), and the big-site
sheaf condition for the Σ-extension `F̃` reduces to *pretopology covers of schemes*
by mathlib's own reduction — the same three-step incantation as the
`subcanonical_zariskiTopology` proof (`BigZariski.lean:57–75`):

1. `Precoverage.isSheaf_toGrothendieck_iff_of_isStableUnderBaseChange`
   (`CategoryTheory/Sites/Coverage.lean:438`) turns
   `Presieve.IsSheaf Scheme.zariskiTopology F̃` into `IsSheafFor` at presieves of the
   precoverage;
2. `exists_cover_of_mem_pretopology` (`AlgebraicGeometry/Sites/Pretopology.lean:78`)
   presents each such presieve as `Presieve.ofArrows 𝓤.X 𝓤.f` for an honest
   `𝓤 : Y.OpenCover`;
3. `Presieve.isSheafFor_arrows_iff` (`CategoryTheory/Sites/IsSheafFor.lean:839`)
   turns `IsSheafFor` at an `ofArrows` into the elementwise ∃!-amalgamation statement
   for `Arrows.Compatible` families — the exact quantifier shape DAT-2's API and the
   evaluation bridge speak.

So Route A = (bridge) + (Σ-bookkeeping) + (three rewrites), and the site gap 1 of the
worksheet closes without touching `GrothendieckTopology.over`. The BigZariski TODO
risk is retired for this campaign.

### Probe evidence, Route A costs (all verified)

- **Σ-extension functor laws.** `F̃.obj T := Σ (a : T ⟶ Spec k'), F(Over.mk a)` needs
  eqToHom transport in the second component for `map_id`/`map_comp` (first components
  move by `id_comp`/`assoc`, which are propositional). Priced: one Σ-transport helper
  (subst-based) + `Over.OverMorphism.ext` against `Over.eqToHom_left`
  (mathlib `Comma/Over/Basic.lean:143`); `CostructuredArrow.eq_mk`
  (`Comma/StructuredArrow/Basic.lean:676`) covers the `Over.mk X.hom = X` eta seam if
  structure-eta `rfl` fails. ~150–220 lines, pure category theory, generic in
  `(C, S, F)`.
- **RepresentableBy Σ-descent.** For `α : F̃.RepresentableBy J`, set
  `u₀ := α.homEquiv (𝟙 J)`; the slice equivalence is
  `homEquiv g := F.map g.op u₀.2` with inverse
  `x ↦ Over.homMk (α.homEquiv.symm ⟨X.hom, x⟩)` (the `w`-proof is the first-component
  equation extracted by `congrArg Sigma.fst`); `homEquiv_comp` is functoriality of
  `F.map`, on the nose. ~60–90 lines. The represented object is **`Over.mk u₀.1`,
  whose `.hom` is literally the Σ-component of the universal element** — the
  worksheet's pin holds definitionally.
- **The sheaf certificate for `F̃`.** Given the bridge (below): glue the Σ-components
  `a_i : U i ⟶ Spec k'` by `Scheme.Cover.glueMorphisms`/`ι_glueMorphisms`/`hom_ext`
  (`AlgebraicGeometry/Gluing.lean:439,451,462`; the pairwise condition is the first
  component of `Arrows.Compatible` at the pullback); the fibre components then form a
  morphism-compatible family on the slice cover `Over.homMk (𝓤.f i)`, which the
  bridge glues uniquely. Uniqueness: `hom_ext` on Σ-components, bridge separation on
  fibres. ~150–200 lines, generic in F given a two-field slice-sheaf certificate
  (`ext` + `glue` in morphism-cover form).
- **The evaluation bridge** (needed by BOTH routes, priced for A): see §2. The
  section-ring iso is cheaper than DAT-2 budgeted: `Scheme.Hom.isIso_app`
  (`OpenImmersion.lean:185`) gives `IsIso (f.app V)` for `V ≤ f.opensRange` directly,
  and `f.appLE V U e` differs from it by a presheaf map along `U ≤ f⁻¹ᵁ V ≤ U`
  (thin-category iso). `IsAffineOpen.preimage_of_isOpenImmersion`
  (`AffineScheme.lean:523`) is exactly the affineness transport. The genuine work is
  the `LocalData` assembly (res/glue fields) and the cross-member `glue` field, which
  needs one mediating object per shared affine open `W`: the open subscheme test
  `Z_W := Over.mk (W.ι ≫ T.hom)` with `IsOpenImmersion.lift`-lifts into both members;
  the mediating ring map `appLEAlgHom ι_W W ⊤` is member-independent (by
  `appLEAlgHom_comp` + congr along `lift_fac`) and injective
  (`Restrict.lean:125` has the `IsIso` for `Opens.ι.appLE` verbatim). ~300–350 lines
  with heartbeat risk at section-ring instance towers (mitigation: the DAT-2/PicEtMap
  `maxHeartbeats 1600000` precedent, opaque of nothing new — the vehicle API carries).

Total Route A: ~700–850 lines across four files, M–L staged, each stage
independently green and committable. No new mathematics; every step is either landed
project API or verified mathlib API.

### Probe evidence, Route B (sanctioned fallback) — REJECTED, costs recorded

Route B (hand-rolled `Scheme.GlueData` from the chart family, mathlib's
`LocalRepresentability.glueData` `Representability.lean:68` as template) was probed
to pricing depth:

- The glue-data fields themselves (`t'`, `cocycle`, `f_open`) port mechanically, BUT
  everything downstream of `yonedaGluedToSheaf` (`:96`) — `sheafValGluedMk` (gluing a
  section of F over the glued object from chart sections), local injectivity
  (`:153`), local surjectivity (`:134`), and `isLocallyBijective_iff_isIso` — is SITE
  machinery on `Sheaf zariskiTopology`. Hand-rolling it in slice ∃!-vocabulary means
  re-proving ~215 lines of mathlib against DAT-2's explicit forms: the
  `sheafValGluedMk` analogue alone is a second gluing engine (sections of `pic0` over
  the glued scheme's cover — the same bridge work as Route A, plus glued-scheme
  `V`-overlap bookkeeping that Route A never sees).
- Route B's statement can only be *parameterized* today: the chart family
  (DAT-C/DAT-B) is not landed, so the entire ~400–500-line development would sit
  against a guessed input shape, coupling DAT-6's landing to Stage-B shape drift.
  Route A's chart-side input is instead mathlib's own `(f, hf, IsLocallySurjective)`
  triple, frozen by 01JJ itself.
- Route B forfeits the 01JJ engine entirely (the worksheet's stated glue mechanism),
  while Route A consumes it verbatim.

Verdict: Route B is strictly dominated. It remains the recorded escape ONLY if the
`Arrows.Compatible`/`glueMorphisms` seam of Route A walls (not expected; both are
verified mathlib API used by mathlib itself in the same pattern).

## §1 Deliverables (staged; commit each green stage)

Base: arbitrary `{k : Type u} [Field k]` of the standing pack (DAT-glue instantiates
at `k'`); curve instances exactly as `Pic0ZariskiSheaf.lean` carries them.

### Stage 1 — `Picard/PicEtCoverBridge.lean` (the evaluation bridge)

Plumbing (generic over the functor):
- `Over.appLEAlgHom_congr_hom`: `appLEAlgHom` respects equality of slice morphisms.
- `Over.bijective_appLEAlgHom (f : T' ⟶ T) [IsOpenImmersion f.left] (hV : V ≤
  f.left.opensRange) (hU : f.left ⁻¹ᵁ V ≤ U)` : the pullback of sections is
  bijective — via `Scheme.Hom.isIso_app` + thin-category iso + `ConcreteCategory`.
- `Over.appLEAlgEquiv`: the same as a `k`-AlgEquiv (`AlgEquiv.ofBijective`).

The bridge proper (at `picEt`, `{ι : Type*}` slice covers, internal reindexing by
points of `T.left` to feed DAT-2's `Type u`-indexed gluing through the exported
`IsGlueValue` API):
- `picEt.coverLocalData`: an abstract slice cover `f i : T' i ⟶ T`
  (`[∀ i, IsOpenImmersion (f i).left]`, jointly surjective on ranges) plus a
  morphism-compatible family `x : ∀ i, picEt C (T' i)` yields `picEt.LocalData` on
  `O i := (f i).left.opensRange` with values
  `v i W hW := mapAlg (appLEAlgEquiv …).symm ((x i).1 ⟨f⁻¹ᵁW, preimage-affine⟩)`.
  Compatibility hypothesis shape (BINDING, the morphism form):
  `∀ i j (Z : Over (Spec k)) (gi : Z ⟶ T' i) (gj : Z ⟶ T' j),
     gi ≫ f i = gj ≫ f j → picEtMap C gi (x i) = picEtMap C gj (x j)`.
- **Keystone** `picEt.existsUnique_of_cover`: `∃! s : picEt C T, ∀ i,
  picEtMap C (f i) s = x i`. (Restriction identity via `picEtMapVal_eq_mapAlg` at
  `V := f ''ᵁ U'`, `IsAffineOpen.image_of_isOpenImmersion`, plus `(x i).compat` along
  `(preimage_image_eq).ge` — no transport, the (C1) discipline.)
- `picEt.ext_of_cover` (separation, morphism form) — from `ext_of_le_cover` +
  `bijective_appLEAlgHom.injective`.
- **Keystone** `pic0.existsUnique_of_cover`: the same at `pic0Subgroup`/`pic0Map`,
  membership of the glued section by DAT-2's S-lemma `mem_pic0Subgroup_of_cover`.

### Stage 2 — `Picard/OverSigmaExtension.lean` (generic Σ-packaging, pure CT)

Generic `{C : Type*} [Category C] (S : C) (F : (Over S)ᵒᵖ ⥤ Type w)`:
- `Over.sigmaExtension S F : Cᵒᵖ ⥤ Type (max v w)` with `obj T = Σ a : T.unop ⟶ S,
  F.obj (op (Over.mk a))`, map by composition/`Over.homMk`; Σ-transport helpers
  (`sigmaExtension_ext`, second-component extraction) — the ONLY place eqToHom lives.
- **Keystone** `Functor.RepresentableBy.overSlice`:
  `(sigmaExtension S F).RepresentableBy J → F.RepresentableBy
  (Over.mk (α.homEquiv (𝟙 J)).1)`.

### Stage 3 — `Picard/Pic0SigmaSheaf.lean` (the honest sheaf + the DAT-glue seam)

- `pic0TypeFunctor C` (abbrev) `:= (pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙
  forget GrpCat` with rfl-lemmas `pic0TypeFunctor_obj/map_apply` (the composite's
  action IS `pic0Map` — own the forget-massage here once for DAT-6's needs;
  JacobianData still owns its own seam per worksheet §1.1).
- `pic0SigmaFunctor C := Over.sigmaExtension _ (pic0TypeFunctor C)`.
- **Keystone** `pic0SigmaFunctor_isSheaf : Presieve.IsSheaf Scheme.zariskiTopology
  (pic0SigmaFunctor C)` — the three-step reduction + Stage-1 bridge; bundled
  **`pic0SigmaSheaf C : Sheaf Scheme.zariskiTopology.{u} (Type u)`** via
  `isSheaf_iff_isSheaf_of_type`.
- **Keystone, the DAT-glue statement** (honest def, chart-family inputs as
  hypotheses):
  ```
  noncomputable def pic0RepresentableByOfCharts
      {ι : Type u} {X : ι → Scheme.{u}}
      (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
      (hf : ∀ i, IsOpenImmersion.presheaf (f i))
      [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
      ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy
        (Over.mk ((Scheme.LocalRepresentability.representableBy hf).homEquiv
          (𝟙 _)).1) :=
    (Scheme.LocalRepresentability.representableBy hf).overSlice
  ```
  The represented object's `.left` is `(Scheme.LocalRepresentability.glueData
  hf).glued` and `.hom` is the universal element's Σ-component — both `rfl`, which is
  what DAT-glue's lft/qc certificates read chart-locally.

**DAT-glue's input obligations (pinned by this spec):** at base `k'`, produce
`ι : Type u`, chart schemes `X i`, chart maps `f i` (by `yonedaEquiv.symm` from pairs
`(a_i : X i ⟶ Spec k', ξ_i : pic0Subgroup C (Over.mk a_i))` — the slice-chart datum),
the relative-representability-by-open-immersions certificates `hf` (DAT-C's open
fibre products), and joint local surjectivity of `Sigma.desc f` (DAT-B's coverage).
Everything else is this brick's.

## §2 Discipline

Standing kernel rules (handoffs 07-14/14b/15) binding: zero sorries, no
Nonempty-smuggling (every keystone above is a def/theorem, never an instance-sorry),
`set_option autoImplicit false`, explicit binders, files ≤ 500 lines, lake mutex on
every build, `lean_verify` axiom-clean on the keystones, campaign rule 1 (never
unfold `picEt`'s carrier — Stage 1 speaks only `picEtMapVal_eq_mapAlg`,
`IsGlueValue`, `compat`, `mapAlg` calculus). Heartbeat risk lives in Stage 1 only;
restructure, never raise past the landed 1600000 precedent.

## §3 Seams / not owned here

- The `forget₂ ⋙ forget` massage is owned at `pic0TypeFunctor`'s rfl-lemmas for this
  brick's statements; JacobianData's own massage (worksheet §1.1) unchanged.
- The chart family, `hf`, and local surjectivity are DAT-glue inputs (Stage B/C).
- `Presheaf.IsLocallySurjective` unfolding helpers for DAT-B's coverage form are
  DAT-glue's to state (the coverage arrives as "pic0 points lift Zariski-locally to
  charts", which is literally the definition at `yonedaEquiv`-transported elements).
- DAT-5's θ-shift functor, if it needs big-site packaging, reuses Stage 2 + the
  generic certificate shape; nothing here is pic0-hard-wired except Stage 3.
