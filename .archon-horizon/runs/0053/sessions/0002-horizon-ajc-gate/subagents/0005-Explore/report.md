Findings.

**1. T13 — genus-0 / Route-C retirement: already done in code, stale in `roadmap.md`**
- `/home/axel/.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/` — **does not exist** (`ls` errors). No `Genus0BaseObjects.lean` either.
- `Genus0` in AJC `AlgebraicJacobian/**/*.lean`: **0 hits**. Nothing imports it.
- `Genus0`/`Route C` in `blueprint/src/**`: **0 hits**. In `README.md`: **0 hits**.
- `Route C` in AJC .lean: **2 hits, both historical prose in docstrings** — `AlgebraicJacobian/Picard/P1SectionsFinite.lean:20` ("Route C … — REJECTED") and `AlgebraicJacobian/RigidityLemma.lean:789`.
- Workspace-root `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md`: **2 stale hits** — line 174 (`Genus0BaseObjects/BareScheme` grading/`Over`/standard-smooth instances) and line 182 (`the genus-0 / Route-C block is retirement work (task T13, inbox I-0106)`). Both reference a directory that no longer exists.
- Other stale references (non-source): `analogies/gm-grpobj-and-friends.md`, `analogies/gmscaling-deep.md`, `analogies/lane-e-projappiso.md`, `informal/projectiveLineBar_geomIrred.md`, and generated `blueprint/web/*.html`.

**2. T10 — `Picard/Pic0AbelianVariety.lean` exists (50191 B)**
- Code `sorry`: **3** — lines **672**, **806**, **826** (the other 8 textual "sorry" hits are docstring prose).
- `tangentSpaceIso` **is present**: line **768**, `theorem Scheme.Pic0.tangentSpaceIso`. Its body is a real proof (`refine nonempty_cotangentSpaceAddEquiv_of_finrank_eq … ; exact finrank_cotangentSpace_eq_finrank_hModuleOne C`) — **not directly sorried**, but it consumes `finrank_cotangentSpaceDual_eq_finrank_h1Cok` (decl ending line **672**, body `sorry`), so it is sorry-tainted transitively.
- Lines 806 / 826 are `Scheme.Pic0.smooth` (`Smooth (Pic0Scheme C).hom := sorry`) and `Scheme.Pic0.proper` (`IsProper … := sorry`).
- Sibling `Picard/Pic0TangentSpace.lean`: **0 sorry**.

**3. T11 — `Albanese/CodimOneExtension.lean` exists (101068 B)**
- Code `sorry`: **1** — line **1751**, inside `theorem indeterminacy_pure_codim_one_into_grpScheme` (declared line **1691**, Milne Lemma 3.3).
- The other extension theorems in the file are sorry-free: `indeterminacy_codimGe2_of_smooth_of_complete` (L1462, Milne Thm 3.1), `codimOneFree_of_smooth_of_complete` (L1570), `existsUnique_hom_of_indeterminacyLocus_eq_empty` (L1636), `localRing_dvr_of_codim_one` (L1355).
- Blocking substeps recorded at L1745-1750: (a) function-field-pullback bridge for `Scheme.RationalMap`, (b) Substep 4b diagonal codim-1 bound. Substep 4a is closed via `Albanese/PolePurity.lean`.
- `Albanese/Thm32RationalMapExtension.lean`: **0 sorry**.

**4. T2 — flat base change (Stacks 02KH): all three live in one file, all three still sorried**
- File: `AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean` — **3 code `sorry`** (of 25 textual hits):
  - L**161-162** `instance pullback_preservesFiniteLimits (g : S' ⟶ S) [Flat g] : Limits.PreservesFiniteLimits (Scheme.Modules.pullback g) := sorry` — **sorried outright**.
  - L**1590** `cech_pushforward_baseChange_natIso` — components built, **naturality sorried** at L**1634** (`(fun {n m} φ => sorry)`).
  - L**1656** `twisted_cech_nerve_iso` — components built, **naturality sorried** at L**1705** (`(fun {n m} φ => sorry)`).
- `Cohomology/FlatBaseChange.lean`: **0 sorry** (sorry-free). `Cohomology/FlatBaseChangeGlobal.lean`: **0 code sorry** (single hit at L32 is docstring prose).

**5. T14 — no ampleness foundation exists**
- `Ample` / `VeryAmple` appear **0 times** in all of AJC `AlgebraicJacobian/**/*.lean`.
- `IsProjectiveMorphism` does not exist. The nearest thing is `AlgebraicJacobian/Picard/ProjectiveMorphism.lean` (9092 B, **0 sorry**), defining `Scheme.Hom.IsProjectiveWith π L` (L75) = "closed immersion into ℙⁿ_S with L the pullback of O(1)"-style predicate, plus sorry-free consequences `isProper` (L89), `locallyOfFiniteType` (L99), `isSeparated` (L103), `universallyClosed` (L108), `of_iso` (L116), `comp_isClosedImmersion` (L124), `baseChange` (L146), `isProjectiveWith_over` (L189). No ampleness abstraction, no `IsProjective` morphism class.
- Serre-finiteness: `AlgebraicJacobian/Picard/SerreFiniteness.lean` (16653 B) has **2 code `sorry`** at L**79** and L**262** (named leaves: Serre's theorem / `sectionGradedModule_fg`). `Cohomology/AffineSerreVanishing.lean` is **sorry-free**. `Picard/SerreTwist.lean`, `Picard/SerreTwistSections.lean`: **0 sorry**.

**6. T15/T12 — `instHasPicScheme`**
- Class `HasPicScheme` declared at `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:225`.
- `noncomputable instance instHasPicScheme` at **L259-263**, hypotheses `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] [HasRationalPoint C]`, body **`⟨sorry⟩`** (L263). So: a real instance head, gated on `HasRationalPoint`, with a **single sorried existence field**.
- `FGAPicRepresentability.lean` total: **1 code `sorry`** (L263); the other 2 textual hits (L75, L212) are docstring prose. `picSharpRepresentable` (L558) and downstream are proved from the `HasPicScheme` existential.

**7. T16 — there is no `Challenge.lean` in AJC**
- `AlgebraicJacobian/Challenge.lean` **does not exist** in the AJC project. `find` over AJC returns nothing.
- Existing copies elsewhere: `/home/axel/LeanAlgebraicGeometry-Horizon/references/challenge.lean` (Christian Merten's original spec) and `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean` (a *different* project).
- AJC's headline module is `AlgebraicJacobian/Jacobian.lean` — **3 code `sorry`**, all named leaves:
  - L**220** `hasRationalPoint_and_geometricallyIntegral`
  - L**234** `smoothOfRelativeDimension_genus_pic0`
  - L**255** `isAlbanese_pic0`
  Everything below (L283 `picardJacobianWitness`, L329 `Jacobian`, L344/348/351 instances) is assembled sorry-free from those three.
- `AlgebraicJacobian/AbelJacobi.lean` (`ofCurve` L60, `exists_unique_ofCurve_comp` L91) and `AlgebraicJacobian/Genus.lean`: **0 sorry**.
- Other code-sorry hotspots in AJC (heuristic, textual-hit upper bounds): `Picard/QuotScheme.lean` (~12), `Albanese/AlbaneseUP.lean` **6** (L335, 382, 416, 453, 496, 533), `Picard/IdentityComponent.lean` **3** (L1432, 1475, 1504), `Picard/FlatteningStratification.lean`, `Picard/QuotFunctorDef.lean`, `Cohomology/AffinePushPullEssImage.lean`.

**8. Documentation defect — CONFIRMED STALE**
- `RiemannRoch/Adelic/P1BaseCase.lean` L139-152 docstring on `class HasFiniteMapToP1` (declared L153) says verbatim: *"This is a **gate** in the `HasPicScheme` style: it is a *Kleiman-independent classical existence statement* — any nonconstant rational function `x ∈ k(C)` determines a finite morphism `C ⟶ ℙ¹_k` of degree `[k(C) : k(x)]`. The class carries **no instance**; the future keystone (`N11`, the reduction of `H¹` finiteness of `C` to the ℙ¹ base case above) consumes it as a hypothesis, and the proved instance (transcendence degree one of `k(C)/k` for a geometrically integral curve) is later work."*
- **This is factually stale.** `RiemannRoch/Adelic/FiniteMapToP1.lean:455-468` declares `instance (priority := 100) hasFiniteMapToP1_of_existsNonconstantMapToP1 … [ExistsNonconstantMapToP1 C] : HasFiniteMapToP1 C` with a **complete proof** (`exact ⟨⟨π, isFinite_left_of_exists_ne π hπ⟩⟩`).
- The chain is in fact fully discharged, so `HasFiniteMapToP1` is **unconditional** for the AJC curve: `RiemannRoch/Adelic/NonconstantToP1.lean:1067` `instance existsNonconstantMapToProjInt_of_ajc … [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] : ExistsNonconstantMapToProjInt C` (proved) → L**136** `instance existsNonconstantMapToP1_of_existsNonconstantMapToProjInt` (proved) → the FiniteMapToP1 instance above. `NonconstantToP1.lean` has **0 sorry**.
- Note a second, milder staleness: `FiniteMapToP1.lean:439-441` says `ExistsNonconstantMapToP1` "carries **no instance**", yet `NonconstantToP1.lean:136` supplies one.
