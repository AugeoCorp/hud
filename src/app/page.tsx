import { Layer } from "@/app/components/Layer";
import { StereoStage } from "@/app/components/StereoStage";

import styles from "./page.module.css";

// Depths are a starting guess, not tuned on the glasses yet.
export default function Home() {
	return (
		<StereoStage>
			<div className={styles.scene}>
				<Layer depth={24} className={styles.panel} />
				<Layer depth={0} className={styles.message}>
					<h1>Hello, world</h1>
				</Layer>
				<Layer depth={-12} className={styles.badge}>
					<span className={styles.flat}>2D</span>
					<span className={styles.stereo}>3D</span>
				</Layer>
			</div>
		</StereoStage>
	);
}
